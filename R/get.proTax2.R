# get.proTax2
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
get.proTax2 <- function(pro.df, con = SerratusConnect()) {

  # Retrieve "family" taxonomy from palmdb for matching
  # palmDB. NOTE: this currently is sOTU based so some
  # identifiers may be missed/ambiguous if it is in
  # a child-OTU

  pro.df$tspe <- get.palmTax2(pro.df$sseqid, con, rank = "species", ordinal = T)
  pro.df$tfam <- get.palmTax2(pro.df$sseqid, con, rank = "family" , ordinal = T)
  pro.df$tphy <- get.palmTax2(pro.df$sseqid, con, rank = "phylum" , ordinal = T)
  pro.df$gbid <- get.palmTax2(pro.df$sseqid, con, rank = "gbid"   , ordinal = T)

  return(pro.df)
}
