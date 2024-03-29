# read.pro
#' Reads a .pro file created by 'diamond'
#' @param pro.path relative system path to .fev file
#' @return A diamond-pro data.frame object
#' @keywords palmid diamond pro
#' @examples
#' # palmDB Alignment file (.pro)
#' pro.path <- system.file( "extdata", "waxsys.pro", package = "palmid")
#' pro.df <- read.pro(pro.path)
#'
#' @import dplyr ggplot2
#' @export
read.pro <- function(pro.path) {
  # read fev as tsv
  pro.df <- utils::read.csv2(pro.path, header = F, sep = "\t",
                      stringsAsFactors=FALSE)

  pro.cols <- c("qseqid", "qstart", "qend", "qlen",
                "sseqid", "sstart", "send", "slen",
                "pident", "evalue", "cigar", "full_sseq")
    colnames(pro.df) <- pro.cols

  # set df.types
    pro.df$qseqid <- as.factor(pro.df$qseqid)
    pro.df$qstart <- as.numeric(pro.df$qstart)
    pro.df$qend   <- as.numeric(pro.df$qend)
    pro.df$qlen   <- as.numeric(pro.df$qlen)
    pro.df$sseqid <- as.character(pro.df$sseqid)
    pro.df$sstart <- as.numeric(pro.df$sstart)
    pro.df$send   <- as.numeric(pro.df$send)
    pro.df$slen   <- as.numeric(pro.df$slen)
    pro.df$pident <- as.numeric(pro.df$pident)
    pro.df$evalue <- as.numeric(pro.df$evalue)
    pro.df$cigar  <- as.character(pro.df$cigar)
    pro.df$full_sseq <- as.character(pro.df$full_sseq)
    
  # Initialize empty nickname column (use get.nickname)
    pro.df$nickname <- as.character(NA)
    
  # Initialize empty taxonomy columns (use get.palmTax)
    pro.df$tspe <- as.character(NA)
    pro.df$tfam <- as.character(NA)
    pro.df$tphy <- as.character(NA)
    
  # Initialize empty palmid to genbank %id
    pro.df$gbid  <- as.numeric(5) # 5% identity is functionally "unmapped"
    pro.df$gbacc <- as.character(NA)

  return(pro.df)
}

