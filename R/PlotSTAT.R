# PlotSTAT
#' Plot a wordcloud of the STAT-classified taxonomy in a palm.sra object
#' using get.sraSTAT()
#' 
#' @param stat.sra  data.frame, created from get.sraSTAT()
#' @return A ggwordcloud object of the "ntop" frequent terms [50]
#' @keywords palmid pro plot
#' @examples
#' \donttest{
#' 
#' con <- SerratusConnect()
#' 
#' # Load Waxsystermes Example data
#' data("waxsys.palm.sra")
#' 
#' waxsys.stat.sra <- get.sraSTAT(waxsys.palm.sra$run_id, con)
#' 
#' # Populate stat.sra with percent identity from palm.sra
#' palm.stat.lookup <- match(waxsys.stat.sra$run_id, waxsys.palm.sra$run_id)
#' waxsys.stat.sra$pident <- waxsys.palm.sra$pident[palm.stat.lookup]
#' 
#' # Create wordcloud of STAT Taxonomy
#' PlotSTAT( waxsys.stat.sra)
#' 
#' }
#' 
#' @import viridisLite ggwordcloud
#' @import dplyr ggplot2
#' @export
PlotSTAT <- function(stat.sra) {
  requireNamespace("ggwordcloud", quietly = TRUE)
  
  # Taxonomy Palette
  tax.color <- data.frame(
    tax_label = c(
      "Primates",
      "Mammalia",
      "Vertebrata",
      "Arthropoda",
      "Metazoa",
      "Fungi",
      "Eukaryota",
      "Archaea",
      "Bacteria",
      "Viruses",
      "Unclassified"),
    tax_color = c(
      "#be0000",
      "#be0043",
      "#be0086",
      "#8700bf",
      "#1600bf",
      "#bfb400",
      "#16bf00",
      "#00553d",
      "#005055",
      "#000000",
      "#000000"
    ) )
  unclassified.color <- tax.color$tax_color[ tax.color$tax_label == "Unclassified"]

  # Bind Local Variables
  order_name <- pident <- tax_color <- kmer_perc <- kperc <- NULL

  if (all(is.na(stat.sra$pident))){
    #TODO: Add support for Frequency-based wordclouds similar to PlotOrgn()
    stop("No pident identity values, assign from palm.sra data.frame")
  }
  
  # Transform Data for Plotting
  # Sort by 'pident', keep highest unique scientific_name match
  stat.sra <- stat.sra[ order(stat.sra$pident, decreasing = T), ]
  
  # Aggregate 'kperc', sum percentage of kmer per runs for each order
  stat.kperc <- stats::aggregate(stat.sra$kmer_perc, by = list(stat.sra$order_name), FUN=sum)
    colnames(stat.kperc) <- c("order_name", "ksum")
    
  # stat.df for Plotting
  # Transform pident to pseudo-Freq
  stat.df      <- stat.sra[ !duplicated(stat.sra$order_name), ]
  stat.df$pident <- ( ((stat.df$pident - 25) / 75) * 9 ) + 1
  
  # Transform kmer_percentage libraries
  stat.df$kperc <- stat.kperc$ksum[match(stat.df$order_name, stat.kperc$order_name)]
    stat.df$kperc[ stat.df$kperc >= 100 ] <- 100
    stat.df$kperc <- stat.df$kperc / 100
  
  ntop <- 50
  stat.df <- stat.df[1:ntop,]
  
  stat.df$tax_color <- tax.color$tax_color[ match(stat.df$tax_label, tax.color$tax_label )]
  stat.df$tax_color[ is.na(stat.df$tax_color) ] <- unclassified.color

  # Plot
  stat.wc <- ggplot() +
    geom_text_wordcloud(data = stat.df, aes(label = order_name,
                                            size  = pident,
                                            color = tax_color,
                                            alpha = kperc)) +
    scale_color_identity() +
    ggtitle(label = "STAT-taxonomy (kmer analysis) associated with input virus -- %id scaled") +
    theme_minimal()
  
  return(stat.wc)
}
