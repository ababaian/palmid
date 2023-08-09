# get.palmVirome
#'
#' A wrapper of several get* functions to create a palm.virome data.frame
#'
#' @param run.vec    character vector, sra run accession list
#' @param org.search string, search term to query "scientific_name". Uses SQL "like"
#' @param con       pq-connection, use SerratusConnect()
#' @return palm.virome  data.frame
#' @keywords palmid sql sra geo biosample bioproject timeline Serratus Tantalus
#' @examples
#'
#' con <- SerratusConnect()
#'
#' \donttest{
#' get.palmVirome(org.search = 'Saccharomyces%', con )
#' }
#'
#' @import dplyr ggplot2
#' @export
#'
get.palmVirome <- function(run.vec    = NA,
                           org.search = NA,
                           con = SerratusConnect() ) {
  
  if ( !is.na(run.vec)[1] ){
  # Get palmVirome based on sra.vec 
  virome.df <- tbl(con, "palm_virome") %>%
    dplyr::filter( run %in% run.vec ) %>%
    as.data.frame()
  } else if ( !is.na(org.search)[1] ) {
  # Get palmVirome based on SQL "like" search of org.search
  # agains the "scientific_name" column
  virome.df <- tbl(con, "palm_virome") %>%
    dplyr::filter( scientific_name %like% org.search ) %>%
    as.data.frame()
  } else {
    stop(paste0("One of 'sra.vec' or 'org.search' must be provided"))
  }
  
  # Check that return is non-empty
  if ( nrow(virome.df) == 0 ){
    stop(paste0("Error: no runs were returned."))
    } else {
    # Set each column class explicitly
    virome.df$run             <- factor(virome.df$run)
    virome.df$scientific_name <- factor(virome.df$scientific_name)
    virome.df$bio_sample      <- factor(virome.df$bio_sample)
    virome.df$bio_project     <- factor(virome.df$bio_project)
    virome.df$palm_id         <- factor(virome.df$palm_id)
    virome.df$sotu            <- factor(virome.df$sotu)
    virome.df$nickname        <- factor(virome.df$nickname)
    virome.df$gb_acc          <- factor(virome.df$gb_acc)
    virome.df$gb_pid          <- as.numeric(virome.df$gb_pid)
    virome.df$gb_eval         <- as.numeric(virome.df$gb_eval)
    virome.df$tax_species     <- factor(virome.df$tax_species)
    virome.df$tax_family      <- factor(virome.df$tax_family)
    virome.df$node            <- factor(virome.df$node)
    virome.df$node_coverage   <- as.numeric(virome.df$node_coverage)
    virome.df$node_pid        <- as.numeric(virome.df$node_pid)
    virome.df$node_eval       <- as.numeric(virome.df$node_eval)
    virome.df$node_qc         <- as.logical(virome.df$node_qc)
    virome.df$node_seq        <- virome.df$node_seq
    }
  
  # Add time (release date) to virome.df
  # virome.df$date <- get.sraDate(virome.df$run_id, con, TRUE)

  # Add geo-data if available to virome.df
  # virome.geo.tmp <- get.sraGeo( run_ids = NULL,
  #                               biosample_ids = virome.df$bio_sample,
  #                               con = con, ordinal =  TRUE)
  # 
  # if (!all(virome.geo.tmp$biosample_id == virome.df$biosample_id)) {
  #   stop("Error in geo lookup.")
  # } else {
  #   virome.df$lng <- virome.geo.tmp$lng
  #   virome.df$lat <- virome.geo.tmp$lat
  # }
  
  return(virome.df)
}

