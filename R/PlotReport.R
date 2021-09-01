# PlotReport
#' A wrapper for palmid Plot* functions to create a standard "report"
#' @param pp A palmprint.df row to use for the plot "value"
#' @param pp.bg A multiple palmprint.df  for the plot background "distribution"
#' @return A grid-table object. Dimension standard is 800 x 400 px.
#' @keywords palmid fev
#' @examples
#' ppRep <- PlotReport(pp, pp.bg)
#' plot(ppRep)
#' @export
PlotReport <- function(pp, pp.bg) {
  
  # Gene Diagram
  pp.line  <- PlotPP(pp)
  
  # Score distribution
  pp.score <- PlotDistro(pp, pp.bg, 'score', 'black')
  
  # Length distribution
  pp.len   <- PlotLengths(pp, pp.bg, set.ylab = NULL)
  
  
  PP.Report <- arrangeGrob( pp.line, pp.score, pp.len,
                            layout_matrix = rbind(c(1, 1),
                                                  c(2, 3),
                                                  c(2, 3)))
  
  return(PP.Report)
}
