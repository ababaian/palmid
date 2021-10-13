#' waxsys.palmprint
#'
#' Waxsystermes Virus example data. Palmprint RdRP-barcode information generated
#' by `palmscan` and imported via read.fev().
#'
#'#' \itemize{
#'   \item score. palmscan PSSM motif score. 20+ is high confidence RdRP
#'   \item query. input fasta query name
#'   \item gene. One of 'RdRP' or 'RT'
#'   \item order. Order of catalytic motifs on input. "ABC" or "CAB"
#'   \item confidence. "high" or "low" confidence classification
#'   \item qlen. input query length. Is truncated on long input sequences
#'   \item pp_start. Start coordinate of palmprint within input sequence
#'   \item pp_end. End coordinate of palmprint within input sequence
#'   \item pp_length. Length of palmprint sequence (in AA)
#'   \item v1_length. Length of v1 region of palmprint
#'   \item v2_length. Length of v2 region of palmprint
#'   \item pssm_total_score. Raw total score of A,B,C motifs
#'   \item pssm_min_score. Lowest scoring PSSM score in palmprint
#'   \item motifs. Isolated A,B,C motifs from palmprint.
#'   \item super. Isolated super-motif residues from A,B,C (catalytic sites)
#'   \item group. Guess of sequence phylum.
#'   \item comments. Summary statement on palmprint QC.
#' }
#'
#' @name waxsys.palmprint
#' @usage data(waxsys.palmprint)
#' @docType data
#' @format data.frame with 1 obs. of 17 variables
#' @keywords waxsystermes-example datasets
#' @source \href{https://github.com/ababaian/serratus/wiki/Find_novel_viruses_B_palmdb}{Waxsystermes Virus Tutorial}
#'
NULL