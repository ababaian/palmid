# PlotID
#' Plot %-identity vs. E-value of a pro file
#' @param pro A diamond-aligned pro file
#' @return A scatterplot as a ggplot2 object
#' @keywords palmid pro plot
#' @examples
#' idPlot <- PlotID(pro)
#'
#' @export
PlotID <- function(pro){
  # Process data for plotting
  pro$escore <- -(log10(pro$evalue))
  pro <- pro[ order(pro$escore, decreasing = T), ]
  
  # Add plot labels for best 10 hits
  pro$label <- ''
  if (length(pro$qseqid) >= 10){
    pro$label[1:10] <- pro$sseqid[1:10]
  } else {
    pro$label <- pro$sseqid
  }
  
  idPlot <- ggplot() +
    geom_point(data = pro, aes(x=pident, y=escore),
               alpha = 0.75) +
    geom_text(data = pro, aes(x=pident, y=escore, label=label),
              color = c("#4D4D4D"),
              hjust = 'right', vjust = "bottom", check_overlap = T) +
    geom_vline( xintercept = c(0, 45, 70, 90),
                color = c("#68228B", "#8B2323", "#8B4500", "#CD9B1D")) +
    ggtitle(label = 'Palmprint alignment to palmDB') +
    xlab('% AA-Identity') + ylab('-log(e-value)') +
    theme_bw()
  
  idPlot
  
  return(idPlot)
}
