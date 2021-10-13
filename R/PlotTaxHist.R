# PlotTaxHist
#' Plot Percent-identity, factored on taxonomic strings of a pro df
#' @param pro.pident numeric, pident column from pro.df
#' @param pro.tax    character, tax column from pro.df (use: get.tax)
#' @param rank       character, string of tax-rank to label graph
#' @return A histogram as a ggplot2 object
#' @keywords palmid taxonomy pro plot
#' @examples
#'
#' data("waxsys.pro.df")
#'
#' taxHist <- PlotTaxHist(pro.pident = waxsys.pro.df$pident,
#'                        pro.tax    = waxsys.pro.df$tfam,
#'                        rank       = "family")
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
PlotTaxHist <- function(pro.pident, pro.tax, rank = NA){
  # Bind Local Variables
  pident <- tax <- NULL

  # Remform dataframe for plotting
  repro <- data.frame( pident = pro.pident,
                       tax    = pro.tax)
  repro <- repro[ order(repro$pident, decreasing = T), ]
  repro$tax[ repro$tax == "." ] <- "Unclassified"

  # Plot title
  if ( class(rank) == "character" ){
    title <- paste0( "PalmDB Taxonomy - ", rank[1])
  } else {
    title <- "PalmDB Taxonomy"
  }

  # Plot colors based on % identity
  repro$tax <- factor( repro$tax, levels = unique(repro$tax) )

  # Use rainbow colors if over 10 taxonomic identifiers
  ntax  <- length( unique( pro.tax ))

  if ( ntax >= 10 ){
    # Use rainbow for >10
    ncolr <- grDevices::rainbow(ntax)
    nlegend <- theme( legend.position = "right")
  } else {
    # Use Viridis for <10
    ncolr <- viridis(ntax)
    nlegend <- theme(legend.justification = c(1,1),
                     legend.position = c(0.95,0.95))
  }

  # set "Unclassified" to gray
  unctax <- which( unique( pro.tax ) == ".")
  if (length(unctax) == 1){
    ncolr[unctax] <- "gray50"
  }

  # Create pallete
  taxHistCol <- scale_fill_manual(values = ncolr,
                                  name   = "Tax.")

  # Taxonomic Histogram Plot
  taxHist <- ggplot() +
    geom_histogram(data = repro, aes(pident, fill = tax),
                   bins = 50) +
    taxHistCol +
    ggtitle(label = title) +
    xlim(c(0,102)) +
    xlab("% AA-identity to Input") + ylab("count") +
    theme_bw() +
    nlegend
  #taxHist

  return(taxHist)
}
