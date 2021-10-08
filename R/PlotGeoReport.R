# PlotGeoReport
#' A multi-plot wrapper to convert a list of SRA `run_ids` into
#' a geographic world-map and timeline.
#' 
#' @param run_ids character, vector of SRA run_id
#' @param con      pq-connection, use SerratusConnect()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' 
#' geoSRA <- PlotGeoReport( run_ids, con )
#'
#' @import ggplotify
#' @import gridExtra
#' @export
PlotGeoReport <- function(run_ids, con = SerratusConnect()) {
  geo      <- as.grob(PlotGeo( run_ids, con))
  timeline <- as.grob(PlotTimeline( run_ids, con))
  
  GeoTime  <- arrangeGrob( geo, timeline,
                           layout_matrix = rbind(c(1, 1),
                                                 c(1, 1),
                                                 c(1, 1),
                                                 c(2, 2)) )
  
  return(GeoTime)
}