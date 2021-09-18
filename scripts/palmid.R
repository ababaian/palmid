#!/usr/bin/env Rscript
# palmid.Rscript
# Generate a palmprint-analysis report for a given RdRP-palmprint.
#   input is a `palmscan`-generated `.fev`
#   output is a `.png` in the same directory
#
# Usage: Rscript palmid.Rscript <path/to/palmprint.fev>
#
# Author: ababaian (artem@rRNA.ca)
# Date  : 2021-09-01
# -----------------------------------------------

# LIBRARES ======================================
#library(ggplot2)
#library(gridExtra)
#library(RPostgreSQL)
#library(dbplyr)
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
input.pro     <- gsub('.fev', '.pro', input.fev)

output.pp     <- args[2]
output.pro    <- gsub('_pp.png', '_pro.png', input.fev)
output.geo    <- gsub('_pp.png', '_geo.png', input.fev)
output.tax    <- gsub('_pp.png', '_tax.png', input.fev)
output.orgn   <- gsub('_pp.png', '_orgn.png', input.fev)

# ID Threshold for inclusion of a palmprint-match
# into the SRA workflow
id_threshold <- 0 #include all

# Establish Serratus server connection
con <- SerratusConnect()

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

# PRO/ALIGN -------------------------------------
#------------------------------------------------
# Import a diamond-alignd pro file
pro.df <- read.pro(input.pro)

# ANALYZE PALMPRINT 
# Generate a palmid-report
pro.report <- PlotProReport(pro.df)

# SAVE PRO-REPORT 
png(filename = output.pro, width = 800, height = 400)
  plot(pro.report)
dev.off()

# TAXREP ----------------------------------------
#------------------------------------------------
# ANALYZE PALMDB TAXONOMY
tax.report <- PlotTaxReport(pro.df)

# SAVE TAX-REPORT 
ggsave(output.tax,
  plot(tax.report),
  width = 16,
  height = 10,
  dpi = 72
)

# GEOTIME ---------------------------------------
#------------------------------------------------
# For each parent and child sOTU, retrieve matching SRA runs
ppdb.hits <- pro.df$sseqid[(pro.df$pident >= id_threshold)]
  palm.uid  <- get.sOTU(ppdb.hits, con, get_childs = T)
  palm.usra <- get.sra(palm.uid, con)

# ANALYZE SRA/BIOSAMPLE SOURCES -----------------
geo.report <- PlotGeoReport(palm.usra, con)

# SAVE GEO-REPORT 
png(filename = output.pro, width = 800, height = 500)
  plot(geo.report)
dev.off()

# SRA-ORGANISM ----------------------------------
#------------------------------------------------
# Retrieve "scientific_name" field of associated sra runs
palm.orgn <- get.sraOrgn(palm.usra, con)
orgn.report <- PlotOrgn( palm.orgn )

# # SAVE ORGN-REPORT 
png(filename = output.orgn, width = 800, height = 400, res = 100)
  plot(orgn.report)
dev.off()
