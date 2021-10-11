#' get.sOTU
#' 
#' Retrieve the parent sOTU for a `palm_id` in palmdb
#' or the set of all children `palm_id` within an species/sOTU
#' 
#' @param palm_ids character, set of `palm_id` to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param get_childs boolean, return all children `palm_id` instead of parent sOTU [F]
#' @param ordinal  boolean, return an ordered sOTU vector based on input `palm_ids`
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
#' # get.sOTU(c('u1','u2',u4'), con, get_childs = F)
#' # -- returns c('u3','u4')
#' 
#' # Return an ordinal list of sOTU for iput
#' # get.sOTU(c('u2','u4','u2','u1'), con, ordinal = T)
#' # -- returns c('u3', 'u4', 'u3', 'u3')
#' 
#' # Return all children palm_id within an sOTU
#' # get.sOTU(c('u2'), con, get_childs = T)
#' # -- returns c('u1', u2', 'u3')
#'
#' con <- SerratusConnect()
#' get.sOTU(c('u1337'), con, get_childs = TRUE)
#'  
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
# Retrieve sOTU or sOTU-palm_ids from an input of a palm_ids 
get.sOTU <- function(palm_ids, con, get_childs = FALSE, ordinal = FALSE) {
  
  # Coerce palm_ids to vector
  if (class(palm_ids) != 'character'){
    palm_ids <- as.character(palm_ids)
  }
  
  # get sOTU from palm_id
  sotus <- tbl(con, 'palmdb') %>%
    filter(palm_id %in% palm_ids) %>%
    select(palm_id, sotu) %>%
    as.data.frame()
    colnames(sotus) <- c('palm_id', 'sotu')
  
  # Bit of a sloppy check here
  if ( length(sotus$sotu) == 0 ){
    stop(paste0(palm_ids, " did not return a valid palm_id."))
  } else if ( length(sotus$sotu) != length(palm_ids)){
    warning("Warning: One or more of the input palm_ids were not retrieved.")
  }
  
  if (get_childs){
    # get palm_ids from sOTU with their children
    sotu.lookup <- as.character(sotus$sotu)
    
    child <- tbl(con, 'palmdb') %>%
      filter(sotu %in% sotu.lookup) %>%
      select(palm_id, sotu) %>%
      as.data.frame()
      colnames(child) <- c('child_id', 'sotu')
    
    # Initialize output list
    out.list <- vector("list", length(palm_ids))
      names(out.list) <- palm_ids
        
    collapseToList <- function(palm, sotu.df, child.df){
      # For each Null palm list,
      # lookup its name (palm_id) sOTU in sotu.df
      # and return all matching child_uid in child.df
      sotu <- sotu.df$sotu[ which(sotu.df$palm_id == palm) ]
      chil <- child.df$child_id[ which(child.df$sotu == sotu)]
      
      return( chil )
    }
    
    out.list <- lapply(names(out.list), collapseToList,
                       sotu.df = sotus, child.df = child)
    names(out.list) <- palm_ids
      
    if (ordinal){
      return(out.list)
    } else {
      unq.child <- unique(unlist(out.list))
      return(unq.child)
    }
    
  } else {
    # get palm_ids of only sOTU
    if (ordinal){
      # Left join on palm_ids to make a unique vector
      ord.sotu <- merge(data.frame( palm_id = palm_ids), sotus,
                        all.x = T, by ="palm_id")
      
      # Add back in duplicates if they are present
      ord.sotu <- ord.sotu$sotu[ match(palm_ids, ord.sotu$palm_id) ]
      
      return(ord.sotu)
      
    } else {
      unq.sotu <- unique(sotus$sotu)
      return(unq.sotu)
    }
  }
}
