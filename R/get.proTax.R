# get.proTax
#' A wrapper for get.palmTax() specific for 'pro.df' input
#' and returns a populated the "tspe", "tfam", and "tphy"
#' columns of 'pro.df' based on the "sseqid" column
#'
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @param con      pq-connection, use SerratusConnect()
#' @return pro.df  data.frame
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#'
#' ## Prepare data
#' # data("waxsys.pro.df")
#' # con <- SerratusConnect()
#'
#' ## Generate Report
#' # geoSRA <- PlotGeoReport( waxsys.pro.df )
#'
#'
#' @import dplyr ggplot2
#' @export
#'
get.proTax <- function(pro.df, con = SerratusConnect()) {

  # Retrieve "family" taxonomy from palmdb for matching
  # palmDB. NOTE: this currently is sOTU based so some
  # identifiers may be missed/ambiguous if it is in
  # a child-OTU

  pro.df$tspe <- get.palmTax(pro.df$sseqid, con, rank = "species", T)
  pro.df$tfam <- get.palmTax(pro.df$sseqid, con, rank = "family", T)
  pro.df$tphy <- get.palmTax(pro.df$sseqid, con, rank = "phylum", T)

  return(pro.df)
}