#' get.sraGeo
#'
#' Retrieve the geo_coordinates for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param biosample_ids character, BioSample `biosample_id`
#' @param con     pq-connection, use SerratusConnect()
#' @param ordinal boolean, return `run_ids` ordered vector [F]
#' @return data.frame, lon and lat numeric vectors
#' @keywords palmid Serratus geo
#' @examples
#' #palm.geo   <- get.sraGeo(palm.sras, con)
#' 
#' @import RPostgreSQL
#' @import dbplyr
#' @import dplyr ggplot2
#' @export
get.sraGeo <- function(run_ids = NULL, biosample_ids = NULL, con, ordinal = FALSE ) {
  
  if ( is.null(run_ids) & is.null(biosample_ids)){
    stop("Input either `run_ids` or `biosamples`, not both")
  } else if ( is.null(biosample_ids) ){
    # If run_ids are provided,
    # first convert to biosample_id
    biosample_ids <- get.sraBio(run_ids, con, ordinal = ordinal)
    biosample_ids <- biosample_ids$biosample_id
  }
  
  # get geo_coordinates for biosample
  # NOTE: WARNINGS ARE SUPPRESSED HERE
  #       This table uses `jsonb` type
  #       which is not supported by
  #       RPostgreSQL
  ##defWarn <- getOption("warn") 
  ##options(warn = -1) 
  
  sra.geo <- tbl(con, 'biosample_geo_coordinates') %>%
    filter(biosample_id %in% biosample_ids) %>%
    select(biosample_id, coordinate_x, coordinate_y) %>%
    as.data.frame()
    colnames(sra.geo) <- c('biosample_id', 'lng', 'lat')
  
  if (ordinal){
    # Left join on biosample_ids to make a unique vector
    ord.geo <- data.frame( biosample_id = biosample_ids )
    ord.geo <- merge(ord.geo, sra.geo, all.x = T, by = "biosample_id")
    ord.geo <- ord.geo[ match(biosample_ids, ord.geo$biosample_id), ]
    
    return(ord.geo)
    
  } else {
    return(sra.geo)
  }
}
