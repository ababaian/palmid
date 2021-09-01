# read.fev
#' Reads a .fev file created by `palmscan` 
#' @param fev.path relative system path to .fev file
#' @param FIRST read only the first palmscan-line in .fev [FALSE]
#' @return A palmscan data.frame object
#' @keywords palmid fev
#' @examples
#' ps <- read.fev(waxsys/waxsys.fev, FIRST = TRUE)
#'
#' @export
read.fev <- function(fev.path, FIRST = FALSE) {
  # read fev as tsv
  fev.tsv <- read.csv2(fev.path, header = F, sep = '\t')
  
  # For single palmprint analysis, only use first palmprint
  if (FIRST) {
    if ( length(fev.tsv[,1]) != 1){
      warning("Warning: Multiple palmprints read from input.fev file\nOnly the first palmprint will be read")
      fev.tsv <- fev.tsv[1,]
    }
  }
  
  # convert field equals value format to data.frame
  fev.df <- as.data.frame( apply(fev.tsv, 2, fev2df) )
  
  return(fev.df)
}