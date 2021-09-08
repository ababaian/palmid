# PlotTax
#' Plot a taxonomic-classifier based histogram
#' @param pro A diamond-aligned pro file
#' @return A histogram ggplot2
#' @keywords palmid pro plot
#' @examples
#' proTax <- PlotTax(pro)
#'
#' @export
PlotTax <- function(pro){
  
  # Taxonomic ranges
  tax <- data.frame(
    rank = factor( 
          c('species', 'genus', 'family', 'phylum'),
           levels = c('phylum', 'family', 'genus', 'species') ),
    llim = c(90,        70,      45,        0),
    ulim = c(101,       90,      70,        45),
    count= c(0, 0, 0, 0) )
  
  # count each taxonomic rank
  for ( i in 1:4 ){
    tax$count[i] <- length(which( pro$pident <  tax$ulim[i]
                                & pro$pident >= tax$llim[i]))
  }
  
  
  # Bar plot of ranks
  taxPlot <- ggplot() +
    geom_col(data = tax, aes(x=rank, y=count, fill = rank),
            show.legend = F) +
    scale_fill_manual(values = c("#68228B", "#8B2323", "#8B4500", "#CD9B1D")) +
    geom_label(data = tax, aes(x = rank, y = 5, label = count)) +
    ggtitle('') + theme_bw()
  
  return(taxPlot)
}
