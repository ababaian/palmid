#' get.sraGeo
#'
#' Retrieve the geo_coordinates for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param biosample_ids character, BioSample `biosample_id`
#' @param con     pq-connection, use SerratusConnect()
#' @return data.frame, lon and lat numeric vectors
#' @keywords palmid Serratus geo
#' @examples
#' palm.geo   <- get.sraGeo(palm.sras, con)
#' 
#' @export
get.sraGeo <- function(run_ids = NULL, con, biosample_ids = NULL) {
  load.lib('sql')
  
  if ( is.null(run_ids) & is.null(biosample_ids)){
    stop("Input either `run_ids` or `biosamples`, not both")
  } else if ( is.null(biosample_ids) ){
    # If run_ids are provided,
    # first convert to biosample_id
    biosample_ids <- get.sraBio(run_ids, con)
    biosample_ids <- biosample_ids$biosample_id
  }
  
  # get geo_coordinates for biosample
  # NOTE: WARNINGS ARE SUPPRESSED HERE
  #       This table uses `jsonb` type
  #       which is not supported by
  #       RpostgreSQL
  ##defWarn <- getOption("warn") 
  ##options(warn = -1) 
  
  sra.geo <- tbl(con, 'biosample') %>%
    filter(biosample_id %in% biosample_ids) %>%
    select(biosample_id, geo_coordinate_x, geo_coordinate_y) %>%
    as.data.frame()
  
  # turn warnings back on
  ##options(warn = defWarn)
  
  colnames(sra.geo) <- c('biosample_id', 'lat', 'lon')
  
  return(sra.geo)
}
