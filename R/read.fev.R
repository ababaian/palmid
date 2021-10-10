# read.fev
#' Reads a .fev file created by `palmscan` 
#' @param fev.path relative system path to .fev file
#' @param FIRST read only the first palmscan-line in .fev [FALSE]
#' @return A palmscan data.frame object
#' @keywords palmid fev
#' @examples
#' 
#' # palmscan fev file
#' ps.fev.path <- system.file( "extdata", "waxsys.fev", package = 'palmid')
#' palmprint <- read.fev(ps.fev.path, FIRST = TRUE)
#'
#' @import dplyr ggplot2
#' @export
read.fev <- function(fev.path, FIRST = FALSE) {
  # read fev as tsv
  fev.tsv <- utils::read.csv2(fev.path, header = F, sep = '\t',
                       stringsAsFactors = FALSE)
  
  # For single palmprint analysis, only use first palmprint
  if (FIRST) {
    if ( length(fev.tsv[,1]) != 1){
      warning("Warning: Multiple palmprints read from input.fev file\nOnly the first palmprint will be read")
      fev.tsv <- fev.tsv[1,]
    }
  }
  
  # convert field equals value format to data.frame
  fev.df <- as.data.frame( apply(fev.tsv, 2, fev2df) )
  
  # Check column names match, return canonical col order
  fev.cols <- c("score", "query", "gene",	"order", "confidence",
                "qlen",	"pp_start",	"pp_end",	"pp_length",
                "v1_length", "v2_length",
                "pssm_total_score", "pssm_min_score",
                "motifs",	"super", 'group', 'comments')
  
  if ( !(all( fev.cols %in% colnames(fev.df))) ) {
    print("fev.input:")
    print(fev.name)
    print("fev.expect:")
    print(fev.cols)
    error_msg <- c(".fev input is missing a fev column")
    stop(error_msg)
  }
  
  fev.df <- fev.df[ , fev.cols]
  
  return(fev.df)
}
