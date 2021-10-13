# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA `run_ids` into
#' a geographic world-map and timeline.
#'
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' data("waxsys.pro.df")
#'
#' proTax <- PlotTaxReport( waxsys.pro.df )
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
PlotTaxReport <- function(pro.df) {

  # Create tax-plot
  PlotTspe <- PlotTaxHist( pro.df$pident, pro.df$tspe, 'species')
  PlotTfam <- PlotTaxHist( pro.df$pident, pro.df$tfam, 'family')
  PlotTphy <- PlotTaxHist( pro.df$pident, pro.df$tphy, 'phylum')

  PalmTax  <- gridExtra::arrangeGrob( PlotTspe, PlotTfam, PlotTphy,
                           layout_matrix = rbind(c(1, 1, 1, 1),
                                                 c(1, 1, 1, 1),
                                                 c(2, 2, 3, 3),
                                                 c(2, 2, 3, 3) ))
    return(PalmTax)
}
