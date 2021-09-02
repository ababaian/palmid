# fev2df
#' Convert a palmscan Field-Equals-Value (FEV) column into a dataframe 
#' @param fev.col character vector of FEV
#' @return A 1-column data.frame
#' @keywords palmid fev
#' @examples
#' fev.df <- as.data.frame( apply(fev.tsv, 2, fev2df) )
#' @export
fev2df <- function(fev.col) {
  # input FEV 
  fev.name  <- gsub('=.*', '', fev.col[1])
  fev.value <- gsub('.*=', '', fev.col)
  
  # check column names match
  fev.cols <- c("score", "query", "gene",	"order", "confidence",
                "qlen",	"pp_start",	"pp_end",	"pp_length",
                "v1_length", "v2_length",
                "pssm_total_score", "pssm_min_score",
                "motifs",	"super", 'comments', 'group')
  
  if ( !(fev.name %in% fev.cols) ) {
    error_msg <- paste0("'", fev.name, "' is not a recognized .fev value")
    stop(error_msg)
  }
  
  # Convert certain columns to different type
  # numerics
  fev.numerics <- c('score', 'qlen', 'pp_start', 'pp_end', 'pp_length',
                    'v1_length', 'v2_length', 'pssm_total_score')
  fev.factors <- c('gene', 'order', 'confidence')
  # else character
  
  if (fev.name %in% fev.numerics) {
    fev.value <- as.numeric(fev.value)
    # factors
  } else if ( fev.name %in% fev.factors) {
    fev.value <- as.factor(fev.value)
  }
  
  # return data.frame
  ret.df <-  data.frame( col1 = fev.value )
  colnames(ret.df) <- fev.name
  
  return(ret.df)
}