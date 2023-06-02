#' waxsys.tree.df
#'
#' Waxsystermes Virus example data. A merged waxsys.pro.df file and waxsys.tree.phy
#' to have cleaned-up labels for plotting on a tree#' 
#' 
#'#' \itemize{
#'   \item qseqid. Query or input sequence name ("SRR9968562_waxsystermes_virus_microassembly")
#'   \item qstart. Coordinate of alignment start, 1 based
#'   \item qend. Coordinate of alignment end, 1 based
#'   \item qlen. Length of aligned sequence on query
#'   \item sseqid. Subject (palmDB) sequence identifier, sOTU used.
#'   \item sstart. Coordinate of alignment start, 1 based
#'   \item send. Coordinate of alignment end, 1 based
#'   \item slen. Length of aligned sequence on query
#'   \item pident. Percent AA-identity between query and subject. (0--100)
#'   \item evalue. Expectance value for alignment
#'   \item cigar. CIGAR alignment string for query alignment
#'   \item full_sseq. Complete subject sequence (including non-aligned)
#'   \item tspe. Taxonomic species of the palmDB match if available, else "."
#'   \item tfam. Taxonomic family of the palmDB match if available, else "."
#'   \item tphy. Taxonomic phylum of the palmDB match if available, else "."
#'   \item gbid. Percent identity mapped to closest GenBank record
#'   \item gbacc. Accession of closest GenBank record.
#' }
#'
#' @name waxsys.tree.df
#' @usage data(waxsys.tree.df)
#' @docType data
#' @format data.frame with 4159 obs. of 13 variables
#' @keywords waxsystermes-example datasets
#' @source \href{https://github.com/ababaian/serratus/wiki/Find_novel_viruses_B_palmdb}{Waxsystermes Virus Tutorial}
#'
NULL