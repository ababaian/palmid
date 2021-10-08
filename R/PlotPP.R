# PlotPP
#' Plot the palmprint-diagram for a palmscan df object 
#' @param ps A palmscan data.frame containing one palmprint
#' @return A gene-diagram as a ggplot2 object
#' @keywords palmid plot
#' @examples
#' pp.diagram <- PlotPP(ps)
#'
#' @import gridExtra
#' @import ggplotify
#' @import viridisLite
#' @import plotly
#' @export
PlotPP <- function(ps){

  # plot variables
  pp.col <- c('red', 'gray50', 'green', 'gray50', 'blue')
  vbump = 0.85
  
  # motif variables
  # length
  mA <- 11
  mB <- 14
  mC <- 7
  
  # Segment coordinates
  ## Query
  ps.query <- data.frame( segment = c('query'),
                          segstrt = 1,
                          segend  = ps$qlen)
  
  ## Palmprint
  # note this uses a mixture of 1- and 0-base such that
  # motif coordinates are correct 0-base and plotting works
  # in ggplot
  ps.pp    <- data.frame(segment = c('A', 'v1', 'B', 'v2', 'C'),
                         segstrt = c(ps$pp_start,
                                     ps$pp_start + mA,
                                     ps$pp_start + mA + ps$v1_length + 1,
                                     ps$pp_start + mA + ps$v1_length + mB,
                                     ps$pp_start + mA + ps$v1_length + mB + ps$v2_length + 1),
                         segend  = c(ps$pp_start + mA,
                                     ps$pp_start + mA + ps$v1_length + 1, 
                                     ps$pp_start + mA + ps$v1_length + mB,
                                     ps$pp_start + mA + ps$v1_length + mB + ps$v2_length + 1,
                                     ps$pp_end))
  
  ppPlot <- ggplot() +
    # Draw Query diagram
    geom_segment(data = ps.query,
                 aes(x = segstrt, xend = segend, y = 0, yend = 0),
                 linetype = 1, size = 4, color = 'gray') +
    xlab('query position (aa)') +
    # Draw Palmprint diagram
    geom_segment(data = ps.pp,
                 aes(x = segstrt, xend = segend, y = 0, yend = 0, color = segment),
                 linetype = 1, size = 10, color = pp.col) +
    geom_text( data = ps.pp,
               aes(x = ((segstrt + segend)/2) , y = vbump, label = segment, hjust = 'center'),
               color = pp.col) +
    ggtitle(label = paste0('>', ps$query)) +
    ylim(c(-1, 1)) +
    xlim(c(0, NA)) +
    theme(axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          axis.title.y=element_blank(),
          legend.position="none",
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          plot.background=element_rect(fill = "white",
                                       colour = "white"))
  
  return(ppPlot)
}
