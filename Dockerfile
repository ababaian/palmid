#==========================================================
# PALMID BASE CONTAINER ===================================
#==========================================================
# Docker Base: amazon linux2
FROM public.ecr.aws/lambda/python:3.9

## Build/test container for palmid
# sudo yum install -y docker git
# sudo service docker start
# git clone https://github.com/ababaian/palmid.git; cd palmid
#
# sudo docker build -t palmid:local
#

## Push to dockerhub
# sudo docker login
# 
# sudo docker build \
#  -t serratusbio/palmid \
#  -t serratusbio/palmid:0.0.0 \
#  -t palmid:latest .
#
# sudo docker push serratusbio/palmid

## Push to ecr (palmid-lambda)
#
# aws ecr-public get-login-password --region us-east-1 \
#  | sudo docker login --username AWS \
#                      --password-stdin public.ecr.aws/q4q7t4w2
#
# docker build -t palmid .
#
# docker tag palmid
#            palmid:0.0.0 \
#            palmid:latest \
#            public.ecr.aws/q4q7t4w2/palmid:latest
# 
# docker push public.ecr.aws/q4q7t4w2/palmid:latest
#

## Dev testing to enter enter
# sudo docker run --rm --entrypoint /bin/bash -it palmid:latest

#==========================================================
# Container Meta-data =====================================
#==========================================================
# Set working directory
# RUN adduser palmid
ARG BASEDIR=/home/palmid
ENV BASEDIR=/home/palmid
WORKDIR /home/palmid

# Container Information
ARG PROJECT='palmid'
ARG TYPE='base'
ARG VERSION='0.0.0'

# Software Versions (pass to shell)
#ENV SAMTOOLSVERSION='1.10'
ENV SEQKITVERSION='2.0.0'
ENV DIAMONDVERSION='2.0.6-dev'
ENV MUSCLEVERSION='3.8.31'
ENV PALMSCANVERSION='1.0'
ENV PALMDBVERSION='2021-03-14'
ENV R='4'

# Additional Metadata
LABEL author="ababaian"
LABEL container.base.image="amazonlinux:2"
LABEL project.name=${PROJECT}
LABEL project.website="https://github.com/ababaian/serratus"
LABEL container.type=${TYPE}
LABEL container.version=${VERSION}
LABEL container.description="palmid-base image"
LABEL software.license="GPLv3"
LABEL tags="palmscan, diamond, muscle, R"

#==========================================================
# Dependencies ============================================
#==========================================================
# Update Core
# RUN yum -y update
RUN yum -y install tar wget gzip which sudo shadow-utils \
           util-linux byacc git

# For development
RUN yum -y install vim htop less

# htslib/samtools
RUN yum -y install gcc make \
    unzip bzip2 bzip2-devel xz-devel zlib-devel \
    curl-devel openssl-devel \
    ncurses-devel

# Python3
RUN yum -y install python3 python3-devel
RUN alias python=python3
RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python3 get-pip.py &&\
    rm get-pip.py

# AWS S3
RUN pip install boto3 awscli
RUN yum -y install jq

# R package dependencies
RUN yum -y install libxml2-devel postgresql-devel

# libgit2-dev required for DT
# 'gert', 'gh', 'jsonlite'

# pandoc for RMarkdown
RUN wget https://github.com/jgm/pandoc/releases/download/2.14.2/pandoc-2.14.2-linux-amd64.tar.gz &&\
  tar xvzf pandoc-2.14.2-linux-amd64.tar.gz --strip-components 1 -C /usr/local &&\
  rm -rf pandoc-2.14.2*

#==========================================================
# Install Software ========================================
#==========================================================

# SeqKit ========================================
RUN wget https://github.com/shenwei356/seqkit/releases/download/v${SEQKITVERSION}/seqkit_linux_amd64.tar.gz &&\
  tar -xvf seqkit* && mv seqkit /usr/local/bin/ &&\
  rm seqkit_linux*

# SAMTOOLS ====================================== (opt?)
## Download
# RUN wget -O /samtools-${SAMTOOLSVERSION}.tar.bz2 \
#   https://github.com/samtools/samtools/releases/download/${SAMTOOLSVERSION}/samtools-${SAMTOOLSVERSION}.tar.bz2 &&\
#   tar xvjf /samtools-${SAMTOOLSVERSION}.tar.bz2 &&\
#   rm /samtools-${SAMTOOLSVERSION}.tar.bz2 &&\
#   cd samtools-${SAMTOOLSVERSION} && make && make install &&\
#   cd .. && rm -rf samtools-${SAMTOOLSVERSION}

# MUSCLE =======================================
RUN wget http://drive5.com/muscle/downloads"$MUSCLEVERSION"/muscle"$MUSCLEVERSION"_i86linux64.tar.gz &&\
  tar -xvf muscle* &&\
  rm muscle*.tar.gz &&\
  mv muscle* /usr/local/bin/muscle

# DIAMOND ======================================
# RUN wget --quiet https://github.com/bbuchfink/diamond/releases/download/v"$DIAMONDVERSION"/diamond-linux64.tar.gz &&\
#   tar -xvf diamond-linux64.tar.gz &&\
#   rm    diamond-linux64.tar.gz &&\
#   mv    diamond /usr/local/bin/

# Use serratus-built dev version
RUN wget --quiet https://serratus-public.s3.amazonaws.com/bin/diamond &&\
    chmod 755 diamond &&\
    mv    diamond /usr/local/bin/

# PALMSCAN ======================================
RUN wget -O /usr/local/bin/palmscan \
  https://github.com/ababaian/palmscan/releases/download/v${PALMSCANVERSION}/palmscan-v${PALMSCANVERSION} &&\
  chmod 755 /usr/local/bin/palmscan

# PALMDB ========================================
# clone repo + make sOTU-database
RUN git clone https://github.com/rcedgar/palmdb.git &&\
  gzip -dr palmdb/* &&\
  cp "palmdb/"$PALMDBVERSION"/otu_centroids.fa" palmdb/palmdb.fa &&\
  diamond makedb --in palmdb/palmdb.fa -d palmdb/palmdb
  # db hash: 0c43dc6647b7ba99b4035bc1b1abf746

# R 4.0 =========================================
# Install R
# Note: 1 GB install
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum -y install R

# R Packages ====================================
RUN \
  R -e 'install.packages( c("roxygen2", "devtools"), repos = "http://cran.us.r-project.org")' &&\
  R -e 'library("devtools"); install_github("ababaian/palmid")'

#==========================================================
# palmid Initialize =======================================
#==========================================================
# scripts + test data
COPY palmid.Rmd ./
COPY scripts/* ./
COPY data/* data/
RUN chmod 755 palmid.sh &&\
    chmod 755 fev2tsv.py

#==========================================================
# Resource Files ==========================================
#==========================================================
# Sequence resources / databases for analysis
# RUN cd /home/palmid/ &&\
#   git clone https://github.com/rcedgar/palmdb.git &&\
#   gzip -dr palmdb/*

# Increase the default chunksize for `aws s3 cp`.  By default it is 8MB,
# which results in a very high number of PUT and POST requests.  These
# numbers have NOT been experimented on, but chosen to be just below the
# max size for a single-part upload (5GB).  I haven't pushed it higher
# because I don't want to test the edge cases where a filesize is around
# the part limit.
# RUN aws configure set default.s3.multipart_threshold 4GB \
#  && aws configure set default.s3.multipart_chunksize 4GB

#==========================================================
# palmid-R initialize =====================================
#==========================================================
# Copy palmidR R package
#COPY R ./
#COPY DESCRIPTION ./
#COPY NAMESPACE ./
#COPY man ./

#==========================================================
# CMD =====================================================
#==========================================================
CMD ["/home/palmid/palmid.sh"]