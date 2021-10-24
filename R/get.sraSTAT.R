#' get.sraSTAT
#'
#' Retrieve the STAT-taxonomy (at the rank of 'order') and the grouping labels
#' for a set of SRA run_ids
#' 
#' Data from NCBI-STAT (Katz et al., 2021)
#'
#' @param run_ids character, SRA 'run_id'
#' @param con     pq-connection, use SerratusConnect()
#' @param prc_threshold  numeric, threshold percent of total reads for tax to retain [5]
#' @return data.frame, with 'run_id', 'order_name', 'label' columns
#' @keywords palmid Serratus STAT taxonomy
#' @examples
#' \donttest{
#'  # Retrieve STAT taxonomic orders for a SRA run
#'  # and show all results with prc_threshold of 0%
#' con <- SerratusConnect()
#' sra.taxa   <- get.sraTax('ERR2756788', con, prc_threshold = 0)
#'
#' }
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
# Retrieve date from input of sra run_ids
get.sraSTAT <- function(run_ids, con = SerratusConnect(), prc_threshold = 5) {
  # Bind Local Variables
  run <- name <- label <- kmer <- kmer_perc <- NULL

  #get STAT kmer taxonomy classifications from SRA
  sra.stat <- tbl(con, "sra_stat") %>%
    filter(run %in% run_ids) %>%
    select(run, name, tax_label, kmer, kmer_perc) %>%
    as.data.frame()
    colnames(sra.stat) <- c("run_id", "order_name", "tax_label", "kmer", "kmer_perc")

  # Filter
  sra.stat <- sra.stat[(sra.stat$kmer_perc >= prc_threshold), ]
  
  # Sort output  
  sra.stat <- sra.stat[order(sra.stat$kmer_perc, decreasing = T), ]
  sra.stat <- sra.stat[order(sra.stat$run_id, sra.stat$tax_label), ]
  
  return(sra.stat)
}
# # Test cases
# con   <- SerratusConnect()
# frank <- get.sraSTAT('ERR2756788', con = con)
# fng   <- get.sraSTAT(c('ERR2756788', 'SRR7287110'), con = con)
# lice  <- get.sraSTAT('SRR1013695', con = con)

