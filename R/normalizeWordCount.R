#' normalizeWordCount
#' Create frequency-count table from a set of characters
#' which are normalized as percentage of total corpus
#'
#' @param  words  character, description of vector [Default]
#' @param  ntop   numeric,   return only N top words [50]
#' @param  logTwo boolean,   apply a log2 transformation [F]
#' @return table, frequency-count table
#' @keywords palmid wordcloud plot
#' @examples
#' NULL
#'
#' @import dplyr ggplot2
#' @export
normalizeWordcount <- function(words, ntop = 50, logTwo = F){
  # Normalize wordcount to shared percentage of all libraries
  # for consistent wordcloud plotting
  # return only `ntop` words
  word.tbl <- table(scientific_name = words[1])
  word.tbl <- word.tbl[ order(word.tbl, decreasing = T) ]
  ntotal <- sum(word.tbl)

  # as integer percentage
  word.tbl2 <- ceiling( 100 * word.tbl / ntotal )

  if (logTwo){
    word.tbl2 <- log2(word.tbl2) + 1
  }

  if ( length(word.tbl2) > ntop){
    word.tbl2 <- word.tbl2[1:ntop]
  }
  return(word.tbl2)
}
