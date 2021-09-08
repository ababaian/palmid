# PlotPro
#' Create PlotID and PlotTax grid-plot
#' @param pro A diamond-aligned pro file
#' @return A grid-table object. Dimension standard is 800 x 400 px.
#' @keywords palmid pro plot
#' @examples
#' proPlot <- PlotPro(pro)
#' plot(proPlot)
#'
#' @export
PlotPro <- function(pro){
  
  # Create individual plots
  id  <- PlotID(pro)
  tax <- PlotTax(pro)
  
  proPlot <- arrangeGrob( id, tax,
                          layout_matrix = rbind(c(1, 1, 2),
                                                c(1, 1, 2)) )
  
  return(proPlot)
}
