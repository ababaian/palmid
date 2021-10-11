# PlotGeo2
#' Create a rich plotly geo map from a palm.sra data.frame
#' 
#' @param palm.sra data.frame, created with get.palmSra(pro.df, con)
#' @return A plotly map
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' # Waxsystermes example data
#' data("waxsys.palm.sra")
#' geoSRA <- PlotGeo2( waxsys.palm.sra )
#'
#' @import leaflet htmltools
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
PlotGeo2 <- function(palm.sra) {
  n.sra  <- length(unique( palm.sra$run_id ))
  
  # HTMLwidget (leaflet) Version ------------------------
  # Clean-up data
  palm.sra <- geoFilter2(palm.sra, wobble = T, wradius = 0.005)
    n.geo  <- length(unique( palm.sra$run_id ))
    nn.stat <- paste0("geo-data for ", n.geo, " / ", n.sra," runs retrieved")
  
  # Color pallette
  ranklvl <-  c('phylum',  'family',  'genus',   'species')
  #rankcols <- c("#8B8B8B", "#8B2323", "#8B4500", "#CD9B1D")
  rankcols <- c("#9f62a1", "#00cc07", "#ff9607", "#ff2a24")
  ranksize <- c(2, 3, 5, 8)
  
  palm.sra$rank <- ranklvl[1]
  palm.sra$colr <- rankcols[1]
  palm.sra$size <- ranksize[1]
  
  palm.sra$rank[palm.sra$pident >= 45] <- ranklvl[2]
  palm.sra$colr[palm.sra$pident >= 45] <- rankcols[2]
  palm.sra$size[palm.sra$pident >= 45] <- ranksize[2]
  
  palm.sra$rank[palm.sra$pident >= 70] <- ranklvl[3]
  palm.sra$colr[palm.sra$pident >= 70] <- rankcols[3]
  palm.sra$size[palm.sra$pident >= 70] <- ranksize[3]
  
  palm.sra$rank[palm.sra$pident >= 90] <- ranklvl[4]
  palm.sra$colr[palm.sra$pident >= 90] <- ranklvl[4]
  palm.sra$size[palm.sra$pident >= 90] <- ranksize[4]
  
  # Populate pop-up labels (HTML format)
  # sra.link <- function(sra){
  #   sra <- paste0('<a href="https://www.ncbi.nlm.nih.gov/sra/?term=',
  #                 sra, '">', sra, '</a>',)
  #   return(sra)
  # }
  
  # Blast link preamble
  blast.l1 <- 'https://blast.ncbi.nlm.nih.gov/Blast.cgi?'
  blast.l2 <- 'PAGE_TYPE=BlastSearch&USER_FORMAT_DEFAULTS=on&SET_SAVED_SEARCH=true&PAGE=Proteins&PROGRAM=blastp&'
  blast.l3q <- 'QUERY='
  blast.l4t <- '&JOB_TITLE='
  blast.l5 <- '&GAPCOSTS=11%201&DATABASE=nr&BLAST_PROGRAMS=blastp&MAX_NUM_SEQ=100&SHORT_QUERY_ADJUST=on&EXPECT=0.05&'
  blast.l6 <- 'WORD_SIZE=6&MATRIX_NAME=BLOSUM62&COMPOSITION_BASED_STATISTICS=2&'
  blast.l7 <- '&PROG_DEFAULTS=on&SHOW_OVERVIEW=on&SHOW_LINKOUT=on&ALIGNMENT_VIEW=Pairwise&'
  blast.l8 <- 'MASK_CHAR=2&MASK_COLOR=1&GET_SEQUENCE=on&NEW_VIEW=on&'
  blast.l9 <- 'NUM_OVERVIEW=100&DESCRIPTIONS=100&ALIGNMENTS=100&FORMAT_OBJECT=Alignment&FORMAT_TYPE=HTML'
  
    palm.sra$popup <- paste0(
      '<b>run_id</b>   : ',
        '<a href="https://serratus.io/explorer/rdrp?run=',
        palm.sra$run_id, '&identity=45-100&score=0-100" target="_blank">', palm.sra$run_id, '</a>',"<br>",
      
      '<b>biosample</b>   : ',
      '<a href="https://www.ncbi.nlm.nih.gov/biosample/',
      palm.sra$biosample_id, '" target="_blank">', palm.sra$biosample_id, '</a>',"<br>",

      "<b>organism</b> : ", palm.sra$scientific_name, "<br>",
      "<b>AA id</b>    : ", palm.sra$pident,          "%<br>",
      "<b>palmprint</b>: ", palm.sra$palm_id,         "<br>",
      "<b>palmprint seq</b>  : <br>",
      "<pre>", gsub("(.{20})", "\\1<br>", palm.sra$sra_sequence), "<br>",
      
      '<a href="', blast.l1, blast.l2,
      blast.l3q, palm.sra$sra_sequence,
      blast.l4t, ">palmID_", palm.sra$run_id, "_", palm.sra$palm_id,
      blast.l5, blast.l6, blast.l7, blast.l8, blast.l9,
      '" target="_blank"> [BLAST] </a>'
      )
    
    earth <-  leaflet(data = palm.sra) %>%
      addCircles(lng = ~lng, lat = ~lat,
                 color = ~colr,
                 weight  = ~size,
                 popup = ~popup,
                 popupOptions = popupOptions(closeButton = F) ) %>%
      addTiles()
    return(earth)
}
