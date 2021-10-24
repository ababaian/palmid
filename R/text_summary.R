# text_summary
#' Create a human-readable text summary of palmID
#' @param pp.in  data.frame, palmprint from read.fev()
#' @param pro.df data.frame, DIAMOND alignment to palmDB from read.pro()
#' @param palm.sra data.frame, palm-sra object from get.palmSra()
#' @param palmdb.hits numeric, original value for all-palmDB hits
#' @return A character-string summary to use with cat()
#' @keywords palmid diamond pro
#'
#' @import dplyr ggplot2
#' @export
#' 
text_summary <- function(pp.in, pro.df, palm.sra, palmdb.hits) {
  # palmDB summary stats
  if (palmdb.hits > length(pro.df[,1])) {
    print.hitn <- paste0("Reporting Top ", length(pro.df[,1]), "/", palmdb.hits, " matches")
  } else {
    print.hitn <-  paste0("Reporting all matches")
  }
  
  hits.min  <- min(pro.df$pident)
  hits.max  <- max(pro.df$pident)
  hits.avg  <- round( mean(pro.df$pident), 1)
  
  # Top match in palmdb
  top.match <- pro.df$sseqid[1]
  top.nick  <- pro.df$nickname[1]
  top.id    <- pro.df$pident[1]
  top.cigar <- pro.df$cigar[1]
  
  
  # Set taxonmic records (if unnamed)
  top.spe <- pro.df$tspe[1]
  top.fam <- pro.df$tfam[1]
  top.phy <- pro.df$tphy[1]
  
  if (top.spe == ".") {
    top.spe <- "unclassified"
  }
  if (top.fam == ".") {
    top.fam <- "unclassified"
  }
  if (top.phy == ".") {
    top.phy <- "unclassified"
  }
  
  # What is the closest named species
  closest.species.i <- which(pro.df$tspe != ".")[1]
  
  if ( is.na(closest.species.i) ) {
    closest.species <- "There are no matching named species."
  } else if (closest.species.i == 1) {
    # If top-hit is named, already reported
    closest.species <- ''
  } else {
    closest.species <- paste0("The closest named species is ",
                              pro.df$sseqid[closest.species.i], " - ",
                              pro.df$tspe[closest.species.i],
                              " at ",
                              pro.df$pident[closest.species.i], "% identity.")
  }
  
  # SRA summary stats
  n.sra     <- length(palm.sra$run_id)
  n.sra.top <- length(palm.sra$run_id[ palm.sra$sOTU == top.match])
  sra.orgn.top <- palm.sra$scientific_name[1]
  
  
  summary <- paste0(
    "## Palmprint Detection \n\n",
    "  RNA-dependent RNA Polymerase detected within input sequence.\n\n",
    
    "  The ", pp.in$pp_length ,"-aa palmprint barcode has a score of ", pp.in$score,
    " (", pp.in$confidence, "-confidence).\n\n",
    
    "## palmDB Search\n\n",
    "  There are ", palmdb.hits, " palmprints matching the input sequence in palmDB.\n  ",
    print.hitn, " with an average aa-identity of ", hits.avg, "% (",
    hits.min," - ",hits.max,"%).\n\n",
    
    "  Top match is '", top.match, " (", top.nick, ")' at ",
    top.id, "% aa-identity \n",
    "  with an alignment CIGAR ", top.cigar, ", and a taxonomy of\n",
    "    species: ", top.spe, "\n",
    "    family : ", top.fam, "\n",
    "    phylum : ", top.phy, "\n\n  ",
    
    closest.species, "\n\n",
    
    "## SRA Search\n\n",  
    "  Matching palmprints identified in ", n.sra,
    " SRA sequencing libraries.\n",
    
    "  Top-palmprint '", top.match, " (", top.nick, ")' was found in ",
    n.sra.top, " libraries,\n",
    "  with top-annotation: ", sra.orgn.top
  )
  
  return(summary)
}

