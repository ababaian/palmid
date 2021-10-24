#' waxsys.stat.sra
#'
#' Waxsystermes Virus example data. NCBI-STAT is a taxonomic a min-hash / kmer
#' based classification of all the reads in the Sequence Read Archive to known
#' organismal genomes and RefSeq viruses. The summary statistics are available
#' on AWS Athena/Google BigQuery. For all of the SRA, kmer classifications at
#' the taxonomic rank of "Orders" was extracted and is available on the Serratus
#' SQL server. This allows for computational host-inference based on the 
#' constellation of organisms associated with a virus across several sequencing
#' libraries.
#' 
#'#' \itemize{
#'   \item run_id. Sequencing library identifier in the SRA
#'   \item order_name. Taxonomic Order (rank) to which kmers are assigned
#'   \item tax_label. palmID plotting label for given order
#'   \item kmer. Count of the number of kmers matching given order
#'   \item kmer_perc. Percent of all kmers for this run_id matching order
#'   \item pident. From get.palmSRA(), aa-percent identity of virus-match to input-virus
#' }
#'
#' @name waxsys.stat.sra
#' @usage data(waxsys.stat.sra)
#' @docType data
#' @format data.frame with 5320 obs. of 6 variables
#' @keywords waxsystermes-example datasets
#' @source \href{https://genomebiology.biomedcentral.com/articles/10.1186/s13059-021-02490-0}{STAT: Katz et al., 2021}
#'
NULL