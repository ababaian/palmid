#' get.nickname
#'
#' Retrieve the nickname for a given 'palm_id' in palmdb
#'
#' @param palm_ids character, set of 'palm_id' to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param ordinal    boolean, return an ordered sOTU vector based on input 'palm_ids' [FALSE]
#' @return character, nickname for each palm_id
#' @keywords palmid Serratus palmdb sOTU
#' @examples
#' 
#' ## R Code Example
#' \donttest{ 
#' con <- SerratusConnect()
#' get.nickname(c("u1337"), con)
#' }
#' 
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
# Retrieve nickname from an input of a palm_ids
get.nickname <- function(palm_ids, con, ordinal = FALSE) {
  # Bind Local Variables
  palm_id <- nickname <- NULL
  
  # Coerce palm_ids to vector
  if (class(palm_ids) != "character") {
    palm_ids <- as.character(palm_ids)
  }
  
  # get sOTU from palm_id
  nicknames <- tbl(con, "palmdb") %>%
    dplyr::filter(palm_id %in% palm_ids) %>%
    select(palm_id, nickname) %>%
    as.data.frame()
  colnames(nicknames) <- c("palm_id", "nickname")
  
  # Bit of a sloppy check here
  if ( length(nicknames$palm_id) == 0 ) {
    stop(paste0(palm_ids, " did not return a valid palm_id."))
  } else if ( length(nicknames$palm_id) != length(palm_ids)) {
    warning(" One or more of the input palm_ids were not retrieved.")
  }

  # get palm_ids of only sOTU
  if (ordinal) {
    # Left join on palm_ids to make a unique vector
    ord.nick <- merge(data.frame( palm_id = palm_ids), nicknames,
                      all.x = TRUE, by = "palm_id")
    
    # Add back in duplicates if they are present
    ord.nick <- ord.nick$nick[ match(palm_ids, ord.nick$palm_id) ]
    
    return(ord.nick)
    
  } else {
    unq.nick <- unique(nicknames$nickname)
    return(unq.nick)
  }
  
}
