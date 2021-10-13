#' waxsys.palm.sra
#'
#' Waxsystermes Virus example data. Sequencing libraries in the Sequence Read
#' Archive (SRA) for which Waxsys or related viruses have been identified in
#' the Serratus Database. Including associated sequencing library meta-data.
#'
#'#' \itemize{
#'   \item run_id. Sequencing library identifier in the SRA
#'   \item palm_id. PalmDB unique identifier for RdRP sequence in library
#'   \item coverage. Read coverage of contig containing RdRP
#'   \item sOTU. Species-like Operational Taxonomic Unit to which palm_id belong
#'   \item qseqid. Input query sequence name
#'   \item pident. Identity between input sequence and respective sOTU
#'   \item evalue. Expectence value for alignment
#'   \item sra_sequence. Matching sequence in the sequence library
#'   \item biosample_id. Corresponding identifier for the biosample database
#'   \item scientific_name. Provided organism meta-data
#'   \item date. Load date for sequencing library
#'   \item lng. Longitude meta-data (if available)
#'   \item lat. Latitude meta-data (if available)
#' }
#'
#' @name waxsys.palm.sra
#' @usage data(waxsys.palm.sra)
#' @docType data
#' @format data.frame with 4159 obs. of 13 variables
#' @keywords waxsystermes-example datasets
#' @source \href{https://github.com/ababaian/serratus/wiki/Find_novel_viruses_B_palmdb}{Waxsystermes Virus Tutorial}
#'
NULL