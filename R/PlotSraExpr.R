# PlotSraExpr
#' Plot the expression of each palm_id-sra (upto top 10)
#' @param palm.sra  data.frame, created from get.palmSra() [NULL]
#' @param ntop      numeric, number of sOTU to return in plot [10]
#' @return A ggplot of per-sOTU expression
#' @keywords palmid sra expression plot
#' @examples
#'
#' # Load Waxsystermes Example data
#' data("waxsys.palm.sra")
#'
#' Plot the contig-coverage of the top10 related sOTU
#' PlotSraExpr( waxsys.palm.sra )
#'
#` # to visualize
#` # plot( PlotSraExpr( waxsys.palm.sra ) )
#` # plotly::ggplotly( PlotSraExpr( waxsys.palm.sra ) )
#'
#' @import dplyr ggplot2
#' @export
PlotSraExpr <- function(palm.sra = NULL, ntop = 10){
  
  # Bind Local Variables
  run_id <- match_rank <- label <- NULL
  coverage <- pident <- 0
  
  if (is.null(palm.sra)){
    stop("A palm.sra input needs to be provided")
  }
  
  # Make Expression Data frame for plotting
  expr.df <- palm.sra[ c('sOTU', 'nickname', 'run_id', 'pident', 'coverage')]
  expr.df$ppLabel <- paste0(expr.df$sOTU, " (", expr.df$nickname, ")" )
  
  # Ordered list of sOTU by pident
  N_sOTU <- unique(expr.df$ppLabel)
  
  # Limit to ntop sOTU
  if (length(N_sOTU) > ntop){
    N_sOTU <- N_sOTU[1:ntop]
    expr.df <- expr.df[ (expr.df$ppLabel %in% N_sOTU) , ]
  }
  
  # Create factor based on label (ordered)
  expr.df$ppLabel <- factor(expr.df$ppLabel, levels = rev(N_sOTU) )
  
  # Assign sOTU rank relative to input
  expr.df <- expr.df %>% 
    mutate(match_rank = case_when(pident == 100 ~ "input",
                                pident <100  & pident >= 90 ~ "species",
                                pident >= 70 & pident < 90 ~ "genus",
                                pident >= 45 & pident < 70 ~ "family",
                                pident < 45 ~ "phylum"))
  rank_colors <- c(
    "phylum" = "#9f62a1",
    "family" = "#00cc07",
    "genus" = "#ff9607",
    "species" = "#ff2a24",
    "input"  = "#000000" )
  
  expr.bar <- ggplot(expr.df, aes(coverage, ppLabel,
                                  color = match_rank,
                                  label = run_id)) +
    geom_violin(orientation = "y", scale = 'width', alpha = 0.25) +
    geom_jitter(size = 3, alpha = 0.8, height = 0.1 , width = 0, stat = "identity") +
    scale_color_manual( values = rank_colors) + 
    theme_bw() + theme(legend.position="none") +
    scale_x_log10() + xlab("Per Contig Coverage (~Virus Expression)") + ylab('')
  #plot(expr.bar)
  #plotly::ggplotly(expr.bar)
  
  return(expr.bar)
}
