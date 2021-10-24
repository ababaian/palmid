#' identityWordcount
#'
#' Create frequency-count table from a set of characters
#' which are assigned a standardized rank-order scores
#' from 10.0 to 1.0.
#'
#' @param  orgn.df  data.frame, scientific_name, pident
#' @param  ntop     numeric,   return only N top words [50]
#' @return table,   identity-count table with 100% - 20% standard
#' @keywords palmid wordcloud plot
#'
#' @import dplyr ggplot2
#' @export
identityWordcount <- function(orgn.df, ntop = 50){
  # Standardize wordcount to fixed-rank values
  # for consistent wordcloud plotting
  # return only 'ntop' words
  # in worcloud2() use:
  #   size = 0.2, ellipticity = 0.5
  
  # Sort by 'pident', keep highest unique scientific_name match
  orgn.df <- orgn.df[ order(orgn.df$pident, decreasing = T), ]
  orgn.df <- orgn.df[ !duplicated(orgn.df$scientific_name), ]

  # Transform pident to pseudo-Freq
  # 100% --> 10
  # 50%  -->  5
  # 25%  -->  1
  orgn.df$Freq <- ( ((orgn.df$pident - 25) / 75) * 9 ) + 1

  return(orgn.df[1:ntop, ])
}
