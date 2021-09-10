#' get.sOTU
#' 
#' Retrieve the parent sOTU for a `palm_id` in palmdb
#' or the set of all children `palm_id` within an species/sOTU
#' 
#' @param palm_ids character, set of `palm_id` to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param get_childs boolean, return all children `palm_id` instead of parent sOTU [F]
#' @return character, unique `palm_id` sOTU or sOTU-children  
#' @keywords palmid Serratus palmdb sOTU
#' @examples
#' # palm_id    sOTU
#' # u1         u3
#' # u2         u3
#' # u3         u3
#' # u4         u4
#' # 
#' 
#' # Retrieve the parent sOTU for an input of palm_ids
#' get.sOTU(c('u2',u4'), con, get_childs = F)
#' # -- returns c('u3',u4')
#' 
#' # Return all children palm_id within an sOTU
#' get.sOTU(c('u2'), con, get_childs = T)
#' # -- returns c('u1', u2', 'u3')
#' 
#' function_name( var1 = x, var2 = T)
#'
#' @export
# Retrieve sOTU or sOTU-palm_ids from an input of a palm_ids 
get.sOTU <- function(palm_ids, con, get_childs = FALSE) {
  # get sOTU from palm_id
  sotus <- tbl(con, 'palmdb') %>%
    filter(palm_id %in% palm_ids) %>%
    select(sotu) %>%
    as.data.frame()
  
  sotus <- as.character(sotus$sotu)
  
  if ( length(sotus) == 0 ){
    stop(paste0(palm_ids, " is not a valid palm_id."))
  } else if ( length(sotus) != length(palm_ids)){
    warning("Warning: One or more of the input palm_ids were not retrieved.")
  }
  
  # get palm_ids from sOTU
  if (get_childs){
    child <- tbl(con, 'palmdb') %>%
      filter(sotu %in% sotus) %>%
      select(palm_id) %>%
      as.data.frame()
    
    child <- as.character(child$palm_id)
    return(unique(child))
    
  } else {
    return(unique(sotus))
  }
  
}