# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA `run_ids` into
#' a geographic world-map and timeline.
#' 
#' @param run_ids character, vector of SRA run_id
#' @param con      pq-connection, use SerratusConnect()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' 
#' geoSRA <- PlotGeoReport( XXX )
#'
#' @export
PlotTaxReport <- function(pro.df, con = SerratusConnect()) {
  load.lib("ggplot")
  
  # Retrieve "family" taxonomy from palmdb for matching
  # palmDB. NOTE: this currently is sOTU based so some
  # identifiers may be missed/ambiguous if it is in
  # a child-OTU
  pro.df$tspe <- get.tax(pro.df$sseqid, con, rank = 'species', T)
  pro.df$tfam <- get.tax(pro.df$sseqid, con, rank = 'family', T)
  pro.df$tphy <- get.tax(pro.df$sseqid, con, rank = 'phylum', T)
  
  # Create tax-plot 
  PlotTspe <- PlotTaxHist( pro.df$pident, pro.df$tspe, 'species')
  PlotTfam <- PlotTaxHist( pro.df$pident, pro.df$tfam, 'family')
  PlotTphy <- PlotTaxHist( pro.df$pident, pro.df$tphy, 'phylum')
  
  PalmTax  <- arrangeGrob( PlotTspe, PlotTfam, PlotTphy,
                           layout_matrix = rbind(c(1, 1, 1, 1),
                                                 c(1, 1, 1, 1),
                                                 c(2, 2, 3, 3),
                                                 c(2, 2, 3, 3) ))
    return(PalmTax)
}
