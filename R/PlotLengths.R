# PlotLengths
#' A wrapper for PlotDistro() for "pp_length", "v1_length", "v2_length".
#' @param pp A palmprint.df row to use for the plot "value"
#' @param pp.bg A multiple palmprint.df  for the plot background "distribution"
#' @param set.ylab Label for y-axis ["palmDB density"]
#' @return A grid-table object of "pp_length", "v1_length", "v2_length"
#' @keywords palmid fev
#' @examples
#' data("waxsys.palmprint")
#' data("palmdb")
#' 
#' ppLen <- PlotLengths(pp = waxsys.palmprint, pp.bg = palmdb)
#' plot(ppLen)
#' 
#' @import gridExtra
#' @import ggplotify
#' @import viridisLite
#' @import plotly
#' @import dplyr ggplot2
#' @export
PlotLengths <- function(pp, pp.bg, set.ylab = 'palmDB density') {

  plPlot    <- PlotDistro( pp, pp.bg, 'pp_length', 'skyblue', set.ylab)
  v1Plot    <- PlotDistro( pp, pp.bg, 'v1_length', 'gray50',  set.ylab)
  v2Plot    <- PlotDistro( pp, pp.bg, 'v2_length', 'gray50',  set.ylab)
  
  lenGrid <- arrangeGrob( plPlot, v1Plot, v2Plot,
                          layout_matrix = rbind(c(1, 1),
                                                c(2, 3)))
  return(lenGrid)
}
