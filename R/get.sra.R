#' get.sra
#'
#' Retrieve the SRA runs containing a microassemblied contig matching
#' a given `palm_id`
#' 
#' @param palm_ids character, set of `palm_id` to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param get_contig.df boolean, return a data.frame of matching contigs [F]
#' @param qc       boolean, require 85% palmprint coverage and e-value < 1e-6
#' @return character, de-duplicated run_ids with a potential match for `palm_ids`
#' @keywords palmid Serratus palmdb sOTU
#' @examples
#' palm.sra   <- get.sra(palm.group, con)
#' 
#' @export
get.sra <- function(palm_ids, con, get_contig.df = FALSE, qc = TRUE) {
  load.lib('sql')
  
  if (qc){
    # get contigs containing palm_ids
    contigs <- tbl(con, 'palm_sra') %>%
      filter(palm_id %in% palm_ids) %>%
      filter(qc_pass == qc) %>%
      as.data.frame()
  } else {
    # get contigs containing palm_ids
    contigs <- tbl(con, 'palm_sra') %>%
      filter(palm_id %in% palm_ids) %>%
      as.data.frame()
  }

  
  # Return contig data.frame or run_id vector
  if ( get_contig.df ){
    return(contigs)
  } else {
    contig.sra <- unique(as.character(contigs$run_id))
    return(contig.sra)
  }
  
}