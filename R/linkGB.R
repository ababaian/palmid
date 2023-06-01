# linkGB
#' Parse an input sequence into a GenBank HTML link
#'
#' @param accession character, header for blast search
#' @param label     character, Display string or accesion var ["<accesion>"]
#' @param database  character, GenBank database to prefix ["protein"]
#' @return character, html link for click to search
#' @keywords palmid sql BLAST html
#' @examples
#'
#' gb.link <- linkGB("VVX76773.1")
#' gb.link <- linkGB("NC_045512.2", label = "SARSCOV2", DB = "nuccore")
#'
#' @import dplyr ggplot2
#' @export
linkGB <- function(accession, label = "<accession>", DB = "protein", prefix_text = NULL){
  
  if (label == "<accession>"){
    label = accession
  }
  # else use user-provided label link
  
    # GenBank Link Parsing
    l0 <- "https://www.ncbi.nlm.nih.gov/"
  
  # Construct link
  url.link <- paste0(
    prefix_text,
    "<a href='", l0, "/",
    DB, "/",
    accession,
    "' target='_blank'> (", label, ")</a>"
  )
}
