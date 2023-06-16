# PlotProjExpr
#' Plot the expression of each palm_id-sra (upto top 10)
#' but grouped by BioProject to look for intra-experiment outliers
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
#' 
PlotProjExpr <- function(palm.sra = NULL, ntop = 10){
  
  ProjZscore   <- function(expr.df = NULL){
    # Initialize Zscore column
    expr.df$Zcov <- 0
    expr.df$Zcov <- NaN
    
    # Sub-Function to return a per-project Z-score for expression
    for (bproj in unique(expr.df$bioproject_id)){
      bp_rows <- (expr.df$bioproject_id == bproj)
      nsamples <- length( which(bp_rows) )
      
      # Require at least 3 data-points to calculate Z-score
      if ( nsamples < 3 ){
        # Do not calculate Z-score
        expr.df$mean[ bp_rows ]  <- mean( expr.df$coverage[ bp_rows ] )
        expr.df$sd[ bp_rows ] <- mean( expr.df$coverage[ bp_rows ] )
        expr.df$Z[ bp_rows ] <- NaN
      } else {
        # Calculate Z-score
        expr.mean <- mean( expr.df$coverage[ bp_rows ] )
        expr.sd   <-   sd( expr.df$coverage[ bp_rows ] )
        
        expr.df$mean[ bp_rows ]  <- expr.mean
        expr.df$sd[ bp_rows ] <- expr.sd 
        expr.df$Z[ bp_rows ] <- (expr.df$coverage[ bp_rows ] - expr.mean) / expr.sd
      }
    }
    return(expr.df)
  }
  
  # Bind Local Variables
  run_id <- match_rank <- label <- NULL
  coverage <- pident <- 0
  
  if (is.null(palm.sra)){
    stop("A palm.sra input needs to be provided")
  }
  
  # Make Expression Data frame for plotting
  expr.df <- palm.sra[ c('sOTU', 'nickname', 'run_id', 'pident', 'coverage', 'bioproject_id')]
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
  
  # Calculate Per-Project Z-score
  expr.df <- ProjZscore(expr.df)
    # calculate fold-change vs mean
    expr.df$fold_change <-  expr.df$coverage / expr.df$mean
    
    # set point shape
    expr.df$point_shape <- 19
    expr.df$point_shape[ is.nan(expr.df$Z) ] <- 1
    # set NaN Z-score to size 1, else use absolute value
    expr.df$point_size <- abs(expr.df$Z) * 3
    expr.df$point_size[ is.nan(expr.df$Z) ] <- 1

    
  expr.var <- ggplot(expr.df, aes(mean, fold_change,
                                  size = point_size,
                                  color = match_rank,
                                  textx = ppLabel,
                                  texty = coverage,
                                  textz = Z,
                                  textb = run_id,
                                  texta = bioproject_id
                                  )) +
    geom_hline(yintercept = 1,   color = 'gray10', ) +
    geom_hline(yintercept = 2,   color = 'gray80', linetype="dashed") +
    geom_hline(yintercept = 0.5, color = 'gray80', linetype="dashed") +
    geom_point(alpha = 0.5) +
    scale_color_manual( values = rank_colors) + 
    theme_bw() + scale_x_log10() + theme(legend.position="none") +
    xlab("Average Per-BioProject Coverage") +
    ylab("Fold Change Per BioSample")
  expr.var
  
  return(expr.var)
}

