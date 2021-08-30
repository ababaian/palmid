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
PIPE_VERSION="0.0"
AMI_VERSION='ami-0fdf24f2ce3c33243'
CONTAINER_VERSION='palmid-base:0.0'


function usage {
  echo ""
  echo "Usage: docker run  -v `pwd`:`pwd` -w `pwd` palmid -i <input.fa> -o <output_prefix> [OPTIONS]"
  echo ""
  echo "    -h    Show this help/usage message"
  echo ""
  echo "    [Required]"
  echo "    -i    input fasta file [nt or aa]*"
  echo "          *(must be in current working dir)"
  echo "    -o    prefix for output files"
  echo ""
  echo "ex: sudo docker run -v `pwd`:`pwd` -w `pwd` palmid -i /home/palmid/test/waxsys.fa -o waxsys"
  echo ""
  exit 1
}

# PARSE INPUT =============================================
INPUT=""
OUTNAME=""

while getopts i:o:h! FLAG; do
  case $FLAG in
    i)
      INPUT=$(readlink -f $OPTARG)
      ;;
    o)
      OUTNAME=$OPTARG
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

# Output options
#echo "Creating dir $OUTNAME"
mkdir -p $OUTNAME

# RUN PALMSCAN ============================================
# currently set with only defaults

palmscan -search_pp $INPUT -hiconf -rdrp \
  -report $OUTNAME/$OUTNAME.txt \
  -fevout $OUTNAME/$OUTNAME.fev \
  -ppout $OUTNAME/$OUTNAME.trim.fa

python3 /home/palmid/fev2tsv.py < $OUTNAME/$OUTNAME.fev > $OUTNAME/$OUTNAME.tsv

