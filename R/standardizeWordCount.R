#' standardizeWordcount
#' Create frequency-count table from a set of characters
#' which are assigned a standardized rank-order scores
#' from 10.0 to 1.0.
#' 
#' @param  words  character, description of vector [Default]
#' @param  ntop   numeric,   return only N top words [50]
#' @return table, frequency-count table with 10:1 standard
#' @keywords palmid wordcloud plot
#' @examples
#' # Desc
#' function_name( var1 = x, var2 = T)
#'
#' @export
standardizeWordcount <- function(words, ntop = 50){
  # Standardize wordcount to fixed-rank values
  # for consistent wordcloud plotting
  # return only `ntop` words
  # in worcloud2() use:
  #   size = 0.2, ellipticity = 0.5
  word.tbl <- table(scientific_name = words[1])
  word.tbl <- word.tbl[ order(word.tbl, decreasing = T) ]
  ntotal <- sum(word.tbl)
  nwords <- length(word.tbl)
  
  # as rank-order from 10 counting down to ntop
  word.tbl2 <- word.tbl[1:ntop]
  word.tbl2[1:ntop] <- seq(10, 1.00001, by = -(9/ntop))
  
  return(word.tbl2)
}
