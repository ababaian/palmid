# PlotOrgn
#' Plot a wordcloud of the 
#' @param orgns  character, vector of "scientific_name" from sra run table
#' @return A ggwordcloud object of the "ntop" frequent terms
#' @keywords palmid pro plot
#' @examples
#' 
#' # Retrive organism identifiers from SRA Run Info Table
#' palm.orgn <- get.sraOrgn(run_ids, con)
#' 
#' # Create wordcloud of organism terms
#' PlotOrgn( palm.orgn )
#'
#' @export
PlotOrgn <- function(orgns){
load.lib("ggplot")
require("ggwordcloud")

# Maximum number of terms to plot
ntop <- 50
# Convert to a standardized table for consistent plotting
orgn.df <- data.frame( standardizeWordcount(orgns, ntop) )


orgn.wc <- ggplot() + 
  geom_text_wordcloud(data = orgn.df, aes(label = scientific_name,
                                          size  = Freq,
                                          color = Freq)) +
  ggtitle(label = 'Sequencing Library Associated Organisms') +
  scale_color_viridis_c(option = "C") +
  theme_minimal()

return(orgn.wc)
}
PlotTax <- function(pro){
  load.lib('ggplot')
  
  rankCols <- c("#8B8B8B", "#8B2323", "#8B4500", "#CD9B1D")
  
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
    scale_fill_manual(values = rankCols) +
    geom_label(data = tax, aes(x = rank, y = 5, label = count)) +
    ggtitle('') + theme_bw()
  
  return(taxPlot)
}
