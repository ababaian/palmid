# linkBLAST
#' Parse an input sequence into a BLAST-able HTML link
#' 
#' @param header   character, header for blast search
#' @param aa.seq   character, query sequence (amino acid)
#' @param label    character, Display string["BLAST"]
#' @return character, html link for click to search
#' @keywords palmid sql BLAST html
#' @examples
#'
#' blast.link <- linkBLAST('u1337', 'MYAASTRING', 'BLAST')
#'
#' @import dplyr ggplot2
#' @export
linkBLAST <- function(header, aa.seq, label = '[BLAST]'){
 
  # Blast link preamble
  l0 <- 'https://blast.ncbi.nlm.nih.gov/Blast.cgi'
  l1 <- '?PAGE_TYPE=BlastSearch&USER_FORMAT_DEFAULTS=on&SET_SAVED_SEARCH=true'
  l2 <- '&PAGE=Proteins&PROGRAM=blastp'
  l3q <- '&QUERY='
  l4t <- '&JOB_TITLE='
  l5 <- '&GAPCOSTS=11%201&DATABASE=nr&BLAST_PROGRAMS=blastp&MAX_NUM_SEQ=100&SHORT_QUERY_ADJUST=on&EXPECT=0.05'
  l6 <- '&WORD_SIZE=6&MATRIX_NAME=BLOSUM62&COMPOSITION_BASED_STATISTICS=2'
  l7 <- '&PROG_DEFAULTS=on&SHOW_OVERVIEW=on&SHOW_LINKOUT=on&ALIGNMENT_VIEW=Pairwise'
  l8 <- '&MASK_CHAR=2&MASK_COLOR=1&GET_SEQUENCE=on&NEW_VIEW=on'
  l9 <- '&NUM_OVERVIEW=100&DESCRIPTIONS=100&ALIGNMENTS=100&FORMAT_OBJECT=Alignment&FORMAT_TYPE=HTML'
 
  # Construct link
  url.link <- paste0(
    '<a href="', l0, l1, l2,
    l3q, aa.seq,
    l4t, ">palmID_", header,
    l5, l6, l7, l8, l9,
    '" target="_blank"> ', label, '</a>'
  )
   
}
