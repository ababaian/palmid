#' get.sraBio
#'
#' Retrieve the "BioSample", "BioProject", or "Both" field for a set of 
#' input SRA 'run_id'
#'
#' @param run_ids character, SRA 'run_id'
#' @param con     pq-connection, use SerratusConnect()
#' @param db_id   character, one of "both", "BioProject", or ["BioSample"] 
#' @param ordinal boolean, return 'run_ids' ordered vector [FALSE]
#' @return data.frame, run_id, biosample character vectors
#' @keywords palmid Serratus geo
#' @examples
#' \donttest{
#' # SRA Library of interest
#' con <- SerratusConnect()
#' library.bioSample   <- get.sraBio( 'SRR9968562' , con)
#' }
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
get.sraBio <- function(run_ids, con, db_id = "BioSample", ordinal = FALSE) {
  # Bind Local Variables
  run <- bio_sample <- biosample_id <- bioproject <- coordinate_x <- coordinate_y <- NULL

  # get biosample field for run_id
  sra.bio <- tbl(con, "srarun") %>%
    dplyr::filter(run %in% run_ids) %>%
    select(run, bio_sample, bio_project) %>%
    as.data.frame()
    colnames(sra.bio) <- c("run_id", "biosample_id", "bioproject")
    # must be unique
    sra.bio <- sra.bio[ !duplicated(sra.bio$run_id), ]

  if (ordinal){
    # Ordinal return
      # Left join on palm_ids to make a unique vector
      ord.bio <- data.frame( run_id = run_ids )
      ord.bio <- merge(ord.bio, sra.bio, all.x = TRUE)
      ord.bio <- ord.bio[ match(run_ids, ord.bio$run_id), ]
    
    # Which columns to return
    if (db_id == "BioSample"){
      return(ord.bio$biosample_id)
    } else if (db_id == "BioProject"){
      return(ord.bio$bioproject)
    } else if (db_id == "Both" | db_id == "both"){
      #return( ord.bio )
      return( ord.bio[ , c("biosample_id", "bioproject")] )
    }
  } else {
    # Non-Ordinal, return unique entries
    
    # Which columns to return
    if (db_id == "BioSample"){
      return( unique(sra.bio$biosample_id) )
    } else if (db_id == "BioProject"){
      return( unique(sra.bio$bioproject) )
    } else if (db_id == "Both" | db_id == "both"){
      return( ord.bio[ , c("biosample_id", "bioproject")] )
    }
  }
}
