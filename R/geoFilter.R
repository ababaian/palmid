# geoFilter
#' Conversion between run_ids and geo objects often contain NA/NULL values
#' This removes NA-containing rows
#' @param sra.geo data.frame, output df from get.sraGeo()
#' @return data.frame
#' @keywords palmid geo
#' @examples
#' 
#' sra.geo.filtered <- geoFilter(sra.geo.full)
#'
#' @export
geoFilter <- function(sra.geo){
  # id, lat, lon data.frame
  
  # Remove NA columns
  sra.geo <- sra.geo[ !is.na(sra.geo$lat), ]
  sra.geo <- sra.geo[ !is.na(sra.geo$lon), ]
  
  # Retain only lat/lon if it's within worldmap coordinates
  sra.geo <- sra.geo[ (sra.geo$lat > -90  & sra.geo$lat < 90), ]
  sra.geo <- sra.geo[ (sra.geo$lon > -180 & sra.geo$lon < 180), ]
  
  return(sra.geo)
}