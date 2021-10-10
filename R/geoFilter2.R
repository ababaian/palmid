# geoFilter2
#' Conversion between run_ids and geo objects often contain NA/NULL values
#' This removes NA-containing rows
#' @param palm.sra data.frame, output df from get.sraGeo()
#' @param wobble   boolean, add a wobble to each point to prevent overplotting [T]
#' @param wradius  numeric, maximum magnitude of wobble [0.005]
#' @return modified palm.sra data.frame
#' @keywords palmid geo
#' @examples
#' 
#' data("waxsys.palm.sra")
#' # waxsys.palm.sra
#' # -- 4159 rows
#' 
#' waxsys.geo.filtered <- geoFilter2(waxsys.palm.sra)
#' # -- 2300 rows
#' 
#' # 2300 / 4159 SRA-libraries have associated geospatial meta-data 
#'
#' @import dplyr ggplot2
#' @export
geoFilter2 <- function(palm.sra, wobble = F, wradius = 0.005){
  # id, lat, lon data.frame
  
  # Remove NA columns
  palm.sra <- palm.sra[ !is.na(palm.sra$lat), ]
  palm.sra <- palm.sra[ !is.na(palm.sra$lng), ]
  
  # Retain only lat/lon if it's within worldmap coordinates
  palm.sra <- palm.sra[ (palm.sra$lat > -90  & palm.sra$lat < 90), ]
  palm.sra <- palm.sra[ (palm.sra$lng > -180 & palm.sra$lng < 180), ]
  
  if (wobble){
    # Generate N random vectors for wobble radius
    latwobs <- wradius * stats::runif( length( palm.sra$lat), -1, 1)
    palm.sra$lat <- palm.sra$lat + latwobs
      
    lngwobs <- wradius * stats::runif( length( palm.sra$lng), -1, 1)
    palm.sra$lng <- palm.sra$lng + lngwobs 
  }
  
  return(palm.sra)
}
