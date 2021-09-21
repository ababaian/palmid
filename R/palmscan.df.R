#' palmscan.df
#'
#' An S4-Object defining the palmscan data.frame. Read from .fev files
#' with the read.fev() function.
#' 
#'  df.cols <- c(
#'  "score", "query", "gene",	"order", "confidence",
#'  "qlen",	"pp_start",	"pp_end",	"pp_length",
#'  "v1_length", "v2_length",
#'  "pssm_total_score", "pssm_min_score",
#'  "motifs",	"super", 'group', 'comments' )
#'
#' 
#' @slot fev palmscan fev
#' @keywords palmid palmscan fev data.frame
#' @export
#' @rdname palmscan.df
palmscan.df <- setClass(Class = "palmscan.df",
                 slots = c(fev = "data.frame"))