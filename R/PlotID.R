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
  load.lib('ggplot')
  
  # phylum, family, genus, species
  rankCols <- c("#8B8B8B", "#8B2323", "#8B4500", "#CD9B1D")
  
  # Process data for plotting
  pro$escore <- -(log10(pro$evalue))
  pro <- pro[ order(pro$escore, decreasing = T), ]
  
  # Add color highlight to hits within the same phylum
  pro$paint <- rankCols[1]
  pro$paint[ which( pro$pident > 45 ) ] <- rankCols[2]
  pro$paint[ which( pro$pident > 70 ) ] <- rankCols[3]
  pro$paint[ which( pro$pident > 90 ) ] <- rankCols[4]
  
  # Add plot labels for best 10 hits within phylum (45%)
  pro$label  <- ''
  if (length(pro$qseqid) >= 10){
    pro$label[1:10] <- pro$sseqid[1:10]
  } else {
    pro$label <- pro$sseqid
  }
  # unassign labels from sub-family match
  pro$label[ which( pro$pident < 45 ) ] <- ''
  
  idPlot <- ggplot() +
    geom_point(data = pro, aes(x=pident, y=escore, color = paint),
               alpha = 0.75) +
    scale_color_identity() +
    geom_text(data = pro, aes(x=pident, y=escore, label=label),
              color = c("#4D4D4D"),
              hjust = 'right', vjust = "bottom", check_overlap = T) +
    geom_vline( xintercept = c(0, 45, 70, 90),
                color = rankCols) +
    ggtitle(label = 'Palmprint alignment to palmDB') +
    xlab('% AA-Identity') + ylab('-log(e-value)') +
    theme_bw()
  
  #idPlot
  
  return(idPlot)
}
