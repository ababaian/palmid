# PlotProReport
#' Create PlotID and PlotTax grid-plot
#' @param pro data.frame, pro.df object
#' @param html boolean, generate htmlWidget instead of ggplot [F]
#' @return A grid-table object. Dimension standard is 800 x 400 px.
#' @keywords palmid pro plot
#' @examples
#' data("waxsys.pro.df")
#'
#' proPlot <- PlotProReport(waxsys.pro.df)
#'
#' plot(proPlot)
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
PlotProReport <- function(pro, html = F){
  # Bind Local Variables
  pro.df <- NULL

  if (html){
    pro.plot <- plotly::hide_legend( PlotID(pro, html = html) )
    tax.plot <- plotly::hide_legend( PlotTax(pro, html = html) )

    proPlot<- plotly::subplot(pro.plot, tax.plot,
                      widths = c(0.8, 0.2),
                      titleX = T, titleY = T) %>%
      plotly::config(displaylogo = FALSE)

    return(proPlot)

  } else {
    # Create individual plots
    id  <- ggplotify::as.grob(PlotID(pro, html = html))
    tax <- ggplotify::as.grob(PlotTax(pro, html = html))

    proPlot <- gridExtra::arrangeGrob( id, tax,
                            layout_matrix = rbind(c(1, 1, 2),
                                                  c(1, 1, 2)) )
  }

  return(proPlot)
}
