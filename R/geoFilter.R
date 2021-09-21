# geoFilter
#' Conversion between run_ids and geo objects often contain NA/NULL values
#' This removes NA-containing rows
#' @param sra.geo data.frame, output df from get.sraGeo()
#' @param wobble  boolean, add a wobble to each point to prevent overplotting [T]
#' @param wradius numeric, maximum magnitude of wobble [0.005]
#' @return data.frame
#' @keywords palmid geo
#' @examples
#' 
#' sra.geo.filtered <- geoFilter(sra.geo.full)
#'
#' @export
geoFilter <- function(sra.geo, wobble = F, wradius = 0.005){
  # id, lat, lon data.frame
  
  # Remove NA columns
  sra.geo <- sra.geo[ !is.na(sra.geo$lat), ]
  sra.geo <- sra.geo[ !is.na(sra.geo$lng), ]
  
  # Retain only lat/lon if it's within worldmap coordinates
  sra.geo <- sra.geo[ (sra.geo$lat > -90  & sra.geo$lat < 90), ]
  sra.geo <- sra.geo[ (sra.geo$lng > -180 & sra.geo$lng < 180), ]
  
  if (wobble){
    # Generate N random vectors for wobble radius
    latwobs <- wradius * runif( length( sra.geo$lat), -1, 1)
    sra.geo$lat <- sra.geo$lat + latwobs
      
    lngwobs <- wradius * runif( length( sra.geo$lng), -1, 1)
    sra.geo$lng <- sra.geo$lng + lngwobs 
  }
  
  return(sra.geo)
}
