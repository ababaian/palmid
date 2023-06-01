# PlotOrgnScatter
#' Plot a scatter-plot of the organisms in a palm.sra object or orgn.vec
#' @param palm.sra  data.frame, created from get.palmSra() [NULL]
#' @param orgn.vec  character, vector of "scientific_name" from sra run table [NULL]
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
PlotOrgnScatter <- function(palm.sra = NULL , orgn.vec = NULL){
  
  # Bind Local Variables
  segstrt <- segend <- segment <- scientific_name <- NULL
  
  if (is.null(palm.sra) & is.null(orgn.vec)){
    stop("One of palm.sra or orgn.vec needs to be provided")
  } else if (!is.null(palm.sra)){
    orgn.df <- data.frame( scientific_name = palm.sra$scientific_name,
                           palm_id         = palm.sra$pident)
  } else {
    orgn.df <- data.frame( scientific_name = orgn.vec,
                           palm_id         = NA )
  }
  
  #otitle <- "Input id% vs. Count of SRA Annotation"
  
  orgn.tbl <- table(orgn.df$scientific_name)
    #orgn.tbl <- orgn.tbl[ order(orgn.tbl, decreasing = T) ]
    orgn.tbl <- data.frame(orgn.tbl)
    colnames(orgn.tbl) <- c("scientific_name", "sra_count")
    orgn.tbl <- merge( orgn.tbl, orgn.df, by = "scientific_name")
    orgn.tbl <- orgn.tbl[order(orgn.tbl$palm_id, decreasing = T), ]
    orgn.tbl <- orgn.tbl[ !duplicated(orgn.tbl$scientific_name), ]
  
  orgn.wc <- ggplot(orgn.tbl, aes(palm_id, sra_count,
                                  color = palm_id,
                                  label = scientific_name,
                                  )) +
    geom_jitter( alpha = 0.75, width = 0.5, height = 0.5) +
    #ggtitle(label = otitle) +
    xlab("Input identity (aa%)") + ylab("Count SRA-Annotation") +
    scale_x_continuous(limits = c(0,100)) +
    scale_y_log10() +
    scale_color_viridis_c(option = "H") +
    theme_minimal() + theme(legend.position="none")
  
  return(orgn.wc)
}
