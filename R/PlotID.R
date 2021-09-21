# PlotID
#' Plot %-identity vs. E-value of a pro file
#' @param pro   data.frame, A diamond-aligned pro file
#' @param html  boolean, include additional parsing for htmlwidget display
#' @return A scatterplot as a ggplot2 object
#' @keywords palmid pro plot
#' @examples
#' idPlot <- PlotID(pro)
#'
#' @export
PlotID <- function(pro, html = T){
  load.lib('ggplot')
  
  # phylum, family, genus, species
  ranklvl <-  c('phylum',  'family',  'genus',   'species')
  rankCols <- c("#8B8B8B", "#8B2323", "#8B4500", "#CD9B1D")
  
  # Process data for plotting
  pro$escore <- -(log10(pro$evalue))
  pro <- pro[ order(pro$escore, decreasing = T), ]
  
  # Add color highlight to hits within the same phylum
  pro$matching <- ranklvl[1]
  pro$matching[ which( pro$pident > 45 ) ] <- ranklvl[2]
  pro$matching[ which( pro$pident > 70 ) ] <- ranklvl[3]
  pro$matching[ which( pro$pident > 90 ) ] <- ranklvl[4]
  
  pro$matching <- factor(pro$matching,
                         levels = ranklvl)
 
  # Add a line-wrapped seq for html display
  pro$seq <- gsub('(.{20})', '\\1\n', pro$full_sseq)
   
  #pro$paint <- rankCols[1]
  #pro$paint[ which( pro$pident > 45 ) ] <- rankCols[2]
  #pro$paint[ which( pro$pident > 70 ) ] <- rankCols[3]
  #pro$paint[ which( pro$pident > 90 ) ] <- rankCols[4]
  
  
  if (html){
    pro$label = ''
  } else {
    # Add plot labels for best 10 hits within phylum (45%)
    pro$label  <- ''
    if (length(pro$qseqid) >= 10){
      pro$label[1:10] <- pro$sseqid[1:10]
    } else {
      pro$label <- pro$sseqid
    }
    # unassign labels from sub-family match
    pro$label[ which( pro$pident < 45 ) ] <- ''
  }
  
  idPlot <- ggplot() +
    geom_point(data = pro, aes(uid=sseqid, seq=seq,
                               x=pident, y=escore, color = matching),
                show.legend = F,
               alpha = 0.75) +
    scale_color_manual(values = rankCols) +
    geom_text(data = pro, aes(x=pident, y=escore, label=label),
              color = c("#4D4D4D"),
              hjust = 'right', vjust = "bottom", check_overlap = T) +
    geom_vline( xintercept = c(0, 45, 70, 90),
                color = rankCols) +
    ggtitle(label = 'Palmprint alignment to palmDB') +
    xlab('% AA-Identity') + ylab('-log(e-value)') +
    theme(legend.position='none') +
    theme_bw()
  
  #idPlot
  
  return(idPlot)
}
