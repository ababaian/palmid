#' get.sraOrgn
#'
#' Retrieve the 'scientific_name' for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param con     pq-connection, use SerratusConnect()
#' @param ordinal boolean, return `run_ids` ordered vector [F]
#' @param as.df   boolean, return run_id, date data.frame [F]
#' @return character, string vector
#' @keywords palmid Serratus taxonomy
#' @examples
#' #palm.orgn   <- get.sraOrg(palm.group, con)
#' 
#' @import RPostgreSQL
#' @import dbplyr
#' @import dplyr ggplot2
#' @export
# Retrieve date from input of sra run_ids
get.sraOrgn <- function(run_ids, con, ordinal = F, as.df = FALSE) {
  
  # get contigs containing palm_ids
  sra.orgn <- tbl(con, 'srarun') %>%
    filter(run %in% run_ids) %>%
    select(run, scientific_name) %>%
    as.data.frame()
    colnames(sra.orgn) <- c("run_id", "scientific_name")
  
  # must be unique
  sra.orgn <- sra.orgn[ !duplicated(sra.orgn$run_id), ]
  
  if (ordinal){
    # Left join on palm_ids to make a unique vector
    ord.orgn <- data.frame( run_id = run_ids )
    ord.orgn <- merge(ord.orgn, sra.orgn, all.x = T)
    ord.orgn <- ord.orgn[ match(run_ids, ord.orgn$run_id), ]
    
    return(ord.orgn$scientific_name)
  } else if (as.df){
    colnames(sra.orgn) <- c('run_id','scientific_name')
  } else {
    sra.orgn <- data.frame( scientific_name = sra.orgn[,2])
  }

  return(sra.orgn)
}
