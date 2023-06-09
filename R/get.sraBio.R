#' get.sraBio
#'
#' Retrieve the "BioSample" field for a set of SRA 'run_id'
#'
#' @param run_ids character, SRA 'run_id'
#' @param con     pq-connection, use SerratusConnect()
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
get.sraBio <- function(run_ids, con, ordinal = FALSE) {
  # Bind Local Variables
  run <- bio_sample <- biosample_id <- coordinate_x <- coordinate_y <- NULL

  # get biosample field for run_id
  sra.bio <- tbl(con, "srarun") %>%
    dplyr::filter(run %in% run_ids) %>%
    select(run, bio_sample, bio_project) %>%
    as.data.frame()
    colnames(sra.bio) <- c("run_id", "biosample_id", "bioproject")
    # must be unique
    sra.bio <- sra.bio[ !duplicated(sra.bio$run_id), ]

  if (ordinal){
    # Left join on palm_ids to make a unique vector
    ord.bio <- data.frame( run_id = run_ids )
    ord.bio <- merge(ord.bio, sra.bio, all.x = TRUE)
    ord.bio <- ord.bio[ match(run_ids, ord.bio$run_id), ]

    return(ord.bio$biosample_id)
  } else {
    unq.bio <- unique(sra.bio$biosample_id)
    return(unq.bio)
  }
}
