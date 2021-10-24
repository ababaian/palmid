# PlotOrgn
#' Plot a wordcloud of the organisms in a palm.sra object or orgn.vec
#' @param palm.sra  data.frame, created from get.palmSra() [NULL]
#' @param orgn.vec  character, vector of "scientific_name" from sra run table [NULL]
#' @param freq      boolean, scale words by frequency, else by identity [TRUE]
#' @return A ggwordcloud object of the "ntop" frequent terms
#' @keywords palmid pro plot
#' @examples
#'
#' # Retrive organism identifiers from SRA Run Info Table
#' # palm.orgn <- get.sraOrgn(run_ids, con)
#'
#' # Load Waxsystermes Exampel data
#' data("waxsys.palm.sra")
#'
#' # Create wordcloud of organism terms
#' # using column "scientific_name" in data.frame
#'
#' # Scaled by frequency of organism term in all of data.frame
#' PlotOrgn( waxsys.palm.sra )
#'
#' # Scaled by proximity of organism tag to input sequence (pident)
#' PlotOrgn( waxsys.palm.sra , freq = FALSE)
#'
#' @import viridisLite ggwordcloud
#' @import dplyr ggplot2
#' @export
PlotOrgn <- function(palm.sra = NULL , orgn.vec = NULL, freq = TRUE){
  requireNamespace("ggwordcloud", quietly = T)

  # Bind Local Variables
  segstrt <- segend <- segment <- scientific_name <- Freq <- NULL

  if (is.null(palm.sra) & is.null(orgn.vec)){
    stop("One of palm.sra or orgn.vec needs to be provided")
  } else if (!is.null(palm.sra)){
    orgn.df <- data.frame( scientific_name = palm.sra$scientific_name,
                         pident          = palm.sra$pident)
  } else {
    orgn.df <- data.frame( scientific_name = orgn.vec,
                         pident          = NA )
  }

  # Maximum number of terms to plot
  if (freq){
    # Transform to a standardized table for consistent plotting
    ntop <- 50
    otitle <- "SRA annotations associated with input virus -- frequency scaled"
    orgn.df <- data.frame( standardizeWordcount(orgn.df, ntop) )
  } else {
    # Transform to an identity-standard table for consistency
    ntop <- 50
    otitle <- "SRA annotations associated with input virus -- %id scaled"
    orgn.df <- identityWordcount(orgn.df, ntop)
  }

  orgn.wc <- ggplot() +
    geom_text_wordcloud(data = orgn.df, aes(label = scientific_name,
                                            size  = Freq,
                                            color = Freq)) +
    ggtitle(label = otitle) +
    scale_color_viridis_c(option = "C") +
    theme_minimal()

  return(orgn.wc)
}
