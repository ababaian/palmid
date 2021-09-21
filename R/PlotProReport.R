# PlotProReport
#' Create PlotID and PlotTax grid-plot
#' @param pro A diamond-aligned pro file
#' @return A grid-table object. Dimension standard is 800 x 400 px.
#' @keywords palmid pro plot
#' @examples
#' proPlot <- PlotPro(pro)
#' plot(proPlot)
#'
#' @export
PlotProReport <- function(pro, html = F){
  load.lib('ggplot')
  
  if (html){
    pro.plot <- hide_legend( PlotID(pro.df, html = html) )
    tax.plot <- hide_legend( PlotTax(pro.df, html = html) )
    
    proPlot<- subplot(pro.plot, tax.plot,
                      widths = c(0.8, 0.2))
    
    return(proPlot)
    
  } else {
    # Create individual plots
    id  <- as.grob(PlotID(pro, html = html))
    tax <- as.grob(PlotTax(pro, html = html))
    
    proPlot <- arrangeGrob( id, tax,
                            layout_matrix = rbind(c(1, 1, 2),
                                                  c(1, 1, 2)) )
  }
  
  return(proPlot)
}
