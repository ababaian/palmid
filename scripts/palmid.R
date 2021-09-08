#!/usr/bin/env Rscript
# palmid.Rscript
# Generate a palmprint-analysis report for a given RdRP-palmprint.
#   input is a `palmscan`-generated `.fev`
#   output is a `.png` in the same directory
#
# Usage: Rscript palmid.Rscript <path/to/palmprint.fev> [path/to/output.png]
#
# Author: ababaian (artem@rRNA.ca)
# Date  : 2021-09-01
# -----------------------------------------------

# LIBRARES ======================================
library(ggplot2)
library(gridExtra)
library(palmid)
#roxygen2::roxygenise()
  load("data/palmdb.Rdata")

# INITIALIZE ====================================

# Read arguments from command-line
args = commandArgs(trailingOnly=TRUE)

# Ensure arguments
# Required ---------------
if (length(args)==0) {
  stop("Path to .fev file is required to run script.")
# Optional ---------------
} else if (length(args)==1) {
  # set default values
  args[2] = gsub('.fev', '_pp.png', args[1])
}

input.fev     <- args[1]
output.report <- args[2]
input.pro     <- gsub('_pp.png', '.pro',     output.report)
output.pro    <- gsub('_pp.png', '_pro.png', output.report)

# SCRIPT ========================================

# PALMSCAN --------------------------------------
#------------------------------------------------
# Import a palmprint-analysis
pp.in <- read.fev(input.fev, FIRST = TRUE)

# ANALYZE PALMPRINT 
# Generate a palmid-report
pp.report <- PlotReport(pp.in, palmdb)

# SAVE PP-REPORT 
png(filename = output.report, width = 800, height = 400)
  plot(pp.report)
dev.off()

# PALMDB ----------------------------------------
#------------------------------------------------
# Import a diamond-alignd pro file
pro.in <- read.pro(input.pro)

# ANALYZE PALMPRINT 
# Generate a palmid-report
pro.report <- PlotPro(pro.in)

# SAVE PRO-REPORT 
png(filename = output.pro, width = 800, height = 400)
  plot(pro.report)
dev.off()

