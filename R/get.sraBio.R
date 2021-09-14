#' get.sraBio
#'
#' Retrieve the "BioSample" field for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param con     pq-connection, use SerratusConnect()
#' @return data.frame, run_id, biosample character vectors
#' @keywords palmid Serratus geo
#' @examples
#' palm.bio   <- get.sraBio(palm.sras, con)
#' 
#' @export
get.sraBio <- function(run_ids, con) {
  load.lib('sql')
  
  # get biosample field for run_id
  sra.bio <- tbl(con, 'srarun') %>%
    filter(run %in% run_ids) %>%
    select(run, bio_sample) %>%
    as.data.frame()
  
  colnames(sra.bio) <- c('run_id', 'biosample_id')
  
  return(sra.bio)
}
