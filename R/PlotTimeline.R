#' PlotTimeline
#' Create a timeline of 
#' 
#' @param sra.date POSIXct, set of dates
#' @return ggplot2, 
#' @keywords palmid timeline
#' @examples
#' sc2.timeline <- PlotTimeline(sra.date)
#' plot(sc2.timeline)
#' 
#' @export
# Retrieve date from input of sra run_ids
PlotTimeline <- function(sra.date){
  timeline <- ggplot( sra.date, aes(date)) +
    geom_histogram(bins = 153) +
    scale_x_datetime(date_breaks = "1 years",
                     date_minor_breaks = "1 month",
                     limits = as.POSIXct( c('2010-01-01','2021-01-02')) ) +
    theme_classic()
  
  return(timeline)
  
}