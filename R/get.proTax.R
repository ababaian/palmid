# get.proTax
#' A wrapper for get.tax() specific for `pro.df` input
#' and returns a populated the "tspe", "tfam", and "tphy"
#' columns of `pro.df` based on the "sseqid" column
#' 
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @param con      pq-connection, use SerratusConnect()
#' @return pro.df  data.frame
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' 
#' geoSRA <- PlotGeoReport( XXX )
#'
#' @export
#' 
#' 
get.proTax <- function(pro.df, con = SerratusConnect()) {
  
  # Retrieve "family" taxonomy from palmdb for matching
  # palmDB. NOTE: this currently is sOTU based so some
  # identifiers may be missed/ambiguous if it is in
  # a child-OTU
  
  pro.df$tspe <- get.tax(pro.df$sseqid, con, rank = 'species', T)
  pro.df$tfam <- get.tax(pro.df$sseqid, con, rank = 'family', T)
  pro.df$tphy <- get.tax(pro.df$sseqid, con, rank = 'phylum', T)
  
  return(pro.df)
}