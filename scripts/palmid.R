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

# Suppress warnings
defaultW <- getOption("warn") 
options(warn = -1) 
# Display warnings
# options(warn = defaultW)


# LIBRARES ======================================
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
output.pro    <- gsub('_pp.png', '_pro.png',  output.pp)
output.geo    <- gsub('_pp.png', '_geo.html', output.pp)
output.tax    <- gsub('_pp.png', '_tax.png',  output.pp)
output.orgn   <- gsub('_pp.png', '_orgn.png', output.pp)

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
png(filename = output.pp, width = 800, height = 400)
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
# Import Taxonomy data into pro.df (Serratus)
pro.df     <- get.proTax(pro.df, con)

# ANALYZE PALMDB TAXONOMY
tax.report <- PlotTaxReport(pro.df)

# SAVE TAX-REPORT 
ggsave(output.tax,
  plot(tax.report),
  width = 16,
  height = 10,
  dpi = 72
)

# PALMSRA ---------------------------------------
#------------------------------------------------
# Perform Serratus SQL queries to retrieve
# parent/child sOTU lookup, sra, biosample, date, organism, geo
palm.sra <- get.palmSra(pro.df, con)


# GEO ORIGINS -----------------------------------
geo.report <- PlotGeo2(palm.sra)

# SAVE GEO-REPORT 
htmlwidgets::saveWidget(geo.report, file=output.geo,
  selfcontained = FALSE)
  # selfcontained requires PANDOC

# SRA-ORGANISM ----------------------------------
#------------------------------------------------
# Retrieve "scientific_name" field of associated sra runs
orgn.report <- PlotOrgn(palm.sra)

# # SAVE ORGN-REPORT 
png(filename = output.orgn, width = 800, height = 400, res = 100)
  plot(orgn.report)
dev.off()
