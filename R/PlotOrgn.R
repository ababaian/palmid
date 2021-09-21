# PlotOrgn
#' Plot a wordcloud of the organisms in a palm.sra object or orgn.vec 
#' @param palm.sra  data.frame, created from get.palmSra() [NULL]
#' @param orgn.vec     character, vector of "scientific_name" from sra run table [NULL]
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
PlotOrgn <- function(palm.sra = NULL , orgn.vec = NULL){
  load.lib("ggplot")
  require("ggwordcloud")
  
  if (is.null(palm.sra) & is.null(orgn.vec)){
    stop("One of palm.sra or orgn.vec needs to be provided")
  } else if (!is.null(palm.sra)){
    orgns <- data.frame( scientific_name = palm.sra$scientific_name )
  } else {
    orgns <- data.frame( scientific_name = orgn.vec )
  }
  
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
