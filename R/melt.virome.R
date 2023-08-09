# melt.virome
#'
#' Melt the virome.df object into a summarized form around sOTU
#'
#' @param virome.df  data.frame, created by get.palmVirome()
#' @return  virx.df  data.frame
#' @keywords palmid sql sra geo biosample bioproject timeline Serratus Tantalus
#' @examples
#'
#'
#' \donttest{
#' virx.df <- melt.virome(virome.df)
#' }
#'
#' @import dplyr ggplot2
#' @export
#'
melt.virome <- function(virome.df) {
  
  # Initialize an sOTU oriented virx.df
  virx.df <- virome.df %>% count(sotu, sort = TRUE)

  # Retrieve the meta-data from virome.df
  virx.df <- merge(virx.df,
                   virome.df[ !duplicated(virome.df$sotu),
                              c("sotu", "nickname", "gb_acc", "gb_pid", "gb_eval", "tax_species", "tax_family")],
                   by = 'sotu')
  
  meanCoverage <- function(virx.df, virome.df){
    # calcualte Average "node_coverage"
    # for the input sOTU (character)
    sotu <- virx.df[1]
    sotu.vector <- (virome.df$sotu == sotu)
    return( mean( virome.df$node_coverage[ sotu.vector ]) )
  }
  
  maxCoverage <- function(virx.df, virome.df){
    # calcualte Average "node_coverage"
    # for the input sOTU (character)
    sotu <- virx.df[1]
    sotu.vector <- (virome.df$sotu == sotu)
    return( max( virome.df$node_coverage[ sotu.vector ]) )
  }
  
  virx.df$mean_coverage <- apply(virx.df, 1, meanCoverage,
                                 virome.df = virome.df)
  
  virx.df$max_coverage  <- apply(virx.df, 1, maxCoverage,
                                 virome.df = virome.df)
  
  return(virx.df)
}

