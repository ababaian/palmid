#!/bin/bash
# ENTRYPOINT SCRIPT ===================
# palmid.sh
# =====================================
set -eu
#
# Base: palmid-base
# Amazon Linux 2 with Docker
# AMI : aami-0fdf24f2ce3c33243
# login: ec2-user@<ipv4>
# base: 9 Gb

# Test cmd: ./serratus-align.sh 
PIPE_VERSION="0.0.2"
AMI_VERSION='ami-0fdf24f2ce3c33243'
CONTAINER_VERSION='palmid-base:0.0.1'


function usage {
  echo ""
  echo "Usage: sudo docker run  -v `pwd`:`pwd` -w `pwd` \
                 --entrypoint "/bin/bash" serratusbio/palmid:latest \
                 /home/palmid/palmid.sh -i <input.fa> -o <output_prefix> [OPTIONS]"
  echo " OR"
  echo "palmid='sudo docker run  -v `pwd`:`pwd` -w `pwd` --entrypoint "/bin/bash" serratusbio/palmid:latest /home/palmid/palmid.sh'"
  echo ""
  echo "\$palmid -i <input.fa> -o <output_prefix> [OPTIONS]"
  echo ""
  echo "    -h    Show this help/usage message"
  echo ""
  echo "    [Required]"
  echo "    -i    input fasta file [nt or aa]*"
  echo "          *(must be in current working dir)"
  echo "    -o    prefix for output files"
  echo ""
  echo "    [Optional]"
  echo "    -d    output directory [<value from -o>]"
  echo ""
  echo "e.g:"
  echo " sudo docker run  -v `pwd`:`pwd` -w `pwd` --entrypoint "/bin/bash" serratusbio/palmid:latest /home/palmid/palmid.sh -i data/waxsys.fa -o waxsys"
  echo ""
  exit 1
}

# SCRIPT ==================================================

echo '================================================='
echo "================ palmID -- $PIPE_VERSION ================"
echo '================================================='
echo 'ababaian (artem@rRNA.ca)'
echo 'issues: https://github.com/ababaian/palmid/issues'
echo ''

# PARSE INPUT =============================================
## test-set
# OUTDIR='data'
# OUTNAME='waxsys'
# DB='/home/palmid/palmdb/palmdb'

# Variable inputs
INPUT=""
OUTNAME=""
OUTDIR=""

# Hardcoded inputs
DB='/home/palmid/palmdb/palmdb'
PALMID='/home/palmid'

# Parse inputs

while getopts i:o:d:h! FLAG; do
  case $FLAG in
    i)
      INPUT=$OPTARG
      ;;
    o)
      OUTNAME=$OPTARG
      ;;
    d)
      OUTDIR=$(readlink -f $OPTARG)
      ;;
    h)  #show help ----------
      usage
      ;;
    \?) #unrecognized option - show help
      echo "Input parameter not recognized"
      usage
      ;;
  esac
done
shift $((OPTIND-1))

# Required Input / Output
if [ -z "$INPUT" ]; then
    echo "Input fasta file (-i) required."
    echo
    usage
    false
    exit 1
fi

if [ -z "$OUTNAME" ]; then
    echo "Output prefix (-o) required."
    usage
    false
    exit 1
fi

# If no explicit output directory set (-d)
# use OUTNAME as directory
if [ -z "$OUTDIR" ]; then
  OUTDIR=$PWD/$OUTNAME
fi

# Output options
#echo "Creating dir $OUTNAME"
mkdir -p $OUTDIR
cp $INPUT $OUTDIR/$OUTNAME.input.fa

# PALMID

# RUN PALMSCAN ============================================
# currently set with only defaults

echo '-- running palmscan RdRP-detection'
echo ''

# palmscan
palmscan -search_pp $INPUT -loconf -rdrp \
  -report $OUTDIR/$OUTNAME.txt \
  -fevout $OUTDIR/$OUTNAME.fev \
  -ppout $OUTDIR/$OUTNAME.trim.fa

echo ''
echo ' palmprint:'
echo ''
cat  $OUTDIR/$OUTNAME.trim.fa
echo ''
echo ' catalytic motifs:'
cat  $OUTDIR/$OUTNAME.txt


# Convert FEV to TSV (DEPRECATED)
#python3 /home/palmid/fev2tsv.py < $OUTDIR/$OUTNAME.fev > $OUTDIR/$OUTNAME.tsv

# RUN DIAMOND =============================================
# currently set with only defaults

echo ''
echo '-- running DIAMOND search of palmDB...'
echo ''

# diamond 1e-6 cutoff 
diamond blastp \
  -q $OUTDIR/$OUTNAME.trim.fa\
  -d $DB \
  --masking 0 -e 0.00001 \
  --tmpdir /tmp \
  --ultra-sensitive -k0 \
  -f 6 qseqid  qstart qend qlen \
       sseqid  sstart send slen \
       pident evalue cigar \
       full_sseq \
  > $OUTDIR/$OUTNAME.pro.tmp

# Sort by alignment identity
sort -nr -k9 $OUTDIR/$OUTNAME.pro.tmp > $OUTDIR/$OUTNAME.pro
rm $OUTDIR/$OUTNAME.pro.tmp

echo " hits in palmDB: $(wc -l $OUTDIR/$OUTNAME.pro)"
  
# RUN MUSCLE =============================================
# create a multiple-sequence alignment of the top 10 hits

echo ''
echo '-- running MUSCLE msa of top-10 hits'
echo ''

# make fasta file of top 10 hits
head -n10  $OUTDIR/$OUTNAME.pro \
  | cut -f5,9,12 - \
  | tr '\t' '_' \
  | sed 's/^/>/g' \
  | sed 's/\(.*\)_/\1\n/g' - \
  >  $OUTDIR/$OUTNAME.10h.tmp

cat $OUTDIR/$OUTNAME.trim.fa $OUTDIR/$OUTNAME.10h.tmp \
  > $OUTDIR/$OUTNAME.msa.input.tmp

# make MSA from sequence and hits
muscle -in  $OUTDIR/$OUTNAME.msa.input.tmp \
       -out $OUTDIR/$OUTNAME.msa.output.tmp

# remove newlines (sequence is on one line)
seqkit head -n 1000 -w 1000 $OUTDIR/$OUTNAME.msa.output.tmp \
  > $OUTDIR/$OUTNAME.msa.fa 

echo ''
echo ' msa:'
cat  $OUTDIR/$OUTNAME.msa.fa 

# Clean-up
rm $OUTDIR/*.tmp

# RUN PALMID ==============================================
# Create visual reports for above data
echo ''
echo '-- running palmID R-visualization package'
echo ''

# palmid HTML-Report
INPUT_PATH="'$OUTDIR/$OUTNAME'"
HTML_OUTPUT="'$OUTDIR/$OUTNAME.html'"

cp /home/palmid/palmid.Rmd /tmp/palmid.Rmd
mkdir -p /tmp/data
cp /home/palmid/data/tax_legend.png /tmp/data/tax_legend.png


Rscript -e "rmarkdown::render( \
  input = '/tmp/palmid.Rmd', \
  output_file = $HTML_OUTPUT, \
  output_format = 'html_notebook', \
  params=list( input.path = $INPUT_PATH , \
               prod.run   = TRUE ))"

