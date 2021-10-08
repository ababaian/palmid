#' PlotTimeline
#' Create a timeline of 
#' 
#' @param run_ids     character, vector of sra run_ids
#' @param sra.dates POSIXct, set of dates
#' @param con      pq-connection, use SerratusConnect()
#' @return ggplot2, timeline of SRA load dates
#' @keywords palmid sql timeline
#' @examples
#' sc2.timeline <- PlotTimeline(sra.date)
#' plot(sc2.timeline)
#'
#' @import gridExtra
#' @import ggplotify
#' @import viridisLite
#' @import plotly
#' @export
# Retrieve date from input of sra run_ids
PlotTimeline <- function(run_ids = NULL, sra.dates = NULL, con = SerratusConnect()){
  
  if ( is.null(run_ids) & is.null(sra.dates) ){
    stop("One of 'run_ids' or 'sra.dates' needs to be set")
  } else if (!is.null(run_ids)){
    sra.date   <- get.sraDate(run_ids, con = con, as.df =  T)
  } else if (!is.null(sra.dates)){
    # do nothing
  }
  
  timeline <- ggplot( sra.date, aes(date)) +
    geom_histogram(bins = 120) +
    scale_x_datetime(date_breaks = "2 years",
                     date_minor_breaks = "1 month",
                     date_labels = "%Y",
                     limits = as.POSIXct( c('2010-01-01','2021-01-02')) ) +
    xlab('Run release date') + ylab('runs') +
    theme_classic()
  
  return(timeline)
  
}
