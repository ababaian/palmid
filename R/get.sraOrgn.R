#' get.sraOrgn
#'
#' Retrieve the 'scientific_name' for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param con     pq-connection, use SerratusConnect()
#' @param as.df   boolean, return run_id, date data.frame [F]
#' @return character, string vector
#' @keywords palmid Serratus taxonomy
#' @examples
#' palm.orgn   <- get.sraOrg(palm.group, con)
#' 
#' @export
# Retrieve date from input of sra run_ids
get.sraOrgn <- function(run_ids, con, as.df = FALSE) {
  load.lib('sql')
  
  # get contigs containing palm_ids
  sra.orgn <- tbl(con, 'srarun') %>%
    filter(run %in% run_ids) %>%
    select(run, scientific_name) %>%
    as.data.frame()
  
  if (as.df){
    colnames(sra.orgn) <- c('run_id','scientific_name')
  } else {
    sra.orgn <- data.frame( scientific_name = sra.orgn[,2])
  }
  
  return(sra.orgn)
}
