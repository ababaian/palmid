#' get.sraDate
#'
#' Retrieve the 'Load_Date' for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param con     pq-connection, use SerratusConnect()
#' @param ordinal boolean, return `run_ids` ordered vector [F]
#' @param as.df   boolean, return run_id, date data.frame [F]
#' @return POSIXct, date object vector
#' @keywords palmid Serratus timeline
#' @examples
#' #palm.date   <- get.sraDate(palm.group, con)
#'
#' @import RPostgreSQL
#' @import dbplyr 
#' @import dplyr ggplot2
#' @export
# Retrieve date from input of sra run_ids
get.sraDate <- function(run_ids, con, ordinal = FALSE, as.df = FALSE) {
  
  # get contigs containing palm_ids
  sra.date <- tbl(con, 'srarun') %>%
    filter(run %in% run_ids) %>%
    select(run, load_date) %>%
    as.data.frame()
    colnames(sra.date) <- c("run_id", "date")
  
  #sra.date <- parse_datetime( sradate$load_data)
  #sra.date <- format( sradate, format = "%y-%m")
  
  if (ordinal){
    # Left join on palm_ids to make a unique vector
    ord.date <- data.frame( run_id = run_ids )
    ord.date <- merge(ord.date, sra.date, all.x = T)
    ord.date <- ord.date[ match(run_ids, ord.date$run_id), ]
    
    return(ord.date$date)
    
  } else if (as.df){
    colnames(sra.date) <- c('run_id','date')
  } else {
    sra.date <- data.frame( date = sra.date[,2])
  }
  
  return(sra.date)
}
