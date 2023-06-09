# linkDB
#' Parse an input sequence into an Accession-based HTML link
#'
#' @param accession character, SRA run_id accession to look-up
#' @param DB        character, GenBank database to prefix ["sra"]
#' @param base_url  character, URL ["https://www.ncbi.nlm.nih.gov/"]
#' @param label     character, Display string or accession var ["<acc>"]
#' @param prefix_text character, prefix to add to label when using accession
#' @param suffix_text character, suffix to add to label when using accession
#' @return character, html link for click to search
#' @keywords palmid sql SRA BioProjects BioSamples NCBI html
#' @examples
#'
#' # Standard SRA link database
#' db.link <- linkDB("ERR2756788")
#' db.link <- linkDB("SRR7287110", label = "Ginger The Cat")
#' 
#' # Link to BioSamples Database
#' db.link <- linkDB("SRR7287110", label = "Ginger The Cat")
#'
#' @import dplyr ggplot2
#' @export
linkDB <- function(accession, DB = "sra", base_url = "https://www.ncbi.nlm.nih.gov",
                   label = "<acc>", prefix_text = NULL, suffix_text = NULL){
  
  if (label == "<acc>"){
    label = accession
  }
  # else use user-provided label link
  
    # Outside Link Parsing
  # Construct link
  url.link <- paste0(
    prefix_text,
    "<a href='", base_url, "/",
    DB, "/",
    accession,
    "' target='_blank'>", label, "</a>",
    suffix_text )
}
