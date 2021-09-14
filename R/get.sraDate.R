#' get.sraDate
#'
#' Retrieve the 'Load_Date' for a set of SRA `run_id`
#' 
#' @param run_ids character, SRA `run_id`
#' @param con     pq-connection, use SerratusConnect()
#' @param as.df   boolean, return run_id, date data.frame [F]
#' @return POSIXct, date object vector
#' @keywords palmid Serratus timeline
#' @examples
#' palm.date   <- get.sraDate(palm.group, con)
#' 
#' @export
# Retrieve date from input of sra run_ids
get.sraDate <- function(run_ids, con, as.df = FALSE) {
  load.lib('sql')
  
  # get contigs containing palm_ids
  sra.date <- tbl(con, 'srarun') %>%
    filter(run %in% run_ids) %>%
    select(run, load_date) %>%
    as.data.frame()
  
  #sra.date <- parse_datetime( sradate$load_data)
  #sra.date <- format( sradate, format = "%y-%m")
  
  if (as.df){
    colnames(sra.date) <- c('run_id','date')
  } else {
    sra.date <- data.frame( date = sra.date[,2])
  }
  
  return(sra.date)
}