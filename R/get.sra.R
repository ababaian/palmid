#' get.sra
#'
#' Retrieve the SRA runs containing a `palm_id`-matching contig.
#'
#' @param palm_ids character or list, set of `palm_id` to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param ret_df   boolean, return a `palm_id` `run_id`, `coverage`, `qsequence` data.frame [F]
#' @param ret_contig.df boolean, return a data.frame of matching contigs [F]
#' @param qc       boolean, require 85-percent palmprint coverage and e-value < 1e-6
#' @return character, de-duplicated run_ids with a potential match for `palm_ids`
#' @keywords palmid Serratus palmdb sOTU
#' @examples
#' palmid_of_interest <- c('u1337')
#' con <- SerratusConnect()
#'
#' palm.sra   <- get.sra(palmid_of_interest, con)
#'
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
get.sra <- function(palm_ids, con,
                    ret_df = FALSE, ret_contig.df = FALSE, qc = TRUE) {
  # Bind Local Variables
  run <- bio_sample <- palm_id <- qc_pass <- NULL

  if (qc){
    # get contigs containing palm_ids WITH QC
    contigs <- tbl(con, 'palm_sra') %>%
      filter(palm_id %in% palm_ids) %>%
      filter(qc_pass == qc) %>%
      as.data.frame()
  } else {
    # get contigs containing palm_ids WITHOUT QC
    contigs <- tbl(con, 'palm_sra') %>%
      filter(palm_id %in% palm_ids) %>%
      as.data.frame()
  }

  # Return a reduced data.frame from contig with input palm_ids
  if ( ret_df ){
    return.df <- contigs[ , c("palm_id", "run_id", "coverage", "q_sequence")]
    return(return.df)

  } else if ( ret_contig.df ){
    # Return full contigs data.frame
    return(contigs)

  } else {
    # return unique sra run_id
    contig.sra <- unique(as.character(contigs$run_id))
    return(contig.sra)
  }
}
