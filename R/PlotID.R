# PlotID
#' Plot Percent-identity vs. E-value of a pro file
#' @param pro   data.frame, A diamond-aligned pro file
#' @param html  boolean, include additional parsing for htmlwidget display [TRUE]
#' @return A scatterplot as a ggplot2 object
#' @keywords palmid pro plot
#' @examples
#' data("waxsys.pro.df")
#' PlotID(waxsys.pro.df)
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
PlotID <- function(pro, html = TRUE){
  # Bind Local Variables
  sseqid <- matching <- label <- seq <- nickname <- NULL
  pident <- evalue <- escore <- 0
  
  # phylum, family, genus, species
  ranklvl <-  c("phylum",  "family",  "genus",   "species")

  rankcols <- c("phylum" = "#9f62a1",
                "family" = "#00cc07",
                "genus"  = "#ff9607",
                "species"= "#ff2a24")

  # Process data for plotting
  pro$escore <- -(log10(pro$evalue))
  pro <- pro[ order(pro$escore, decreasing = TRUE), ]

  # Add color highlight to hits within the same phylum
  pro$matching <- ranklvl[1]
  pro$matching[ which( pro$pident >= 45 ) ] <- ranklvl[2]
  pro$matching[ which( pro$pident >= 70 ) ] <- ranklvl[3]
  pro$matching[ which( pro$pident >= 90 ) ] <- ranklvl[4]

  pro$matching <- factor(pro$matching,
                         levels = ranklvl)

  # Add a line-wrapped seq for html display
  pro$seq <- gsub("(.{20})", "\\1\n", pro$full_sseq)

  #pro$paint <- rankCols[1]
  #pro$paint[ which( pro$pident > 45 ) ] <- rankCols[2]
  #pro$paint[ which( pro$pident > 70 ) ] <- rankCols[3]
  #pro$paint[ which( pro$pident > 90 ) ] <- rankCols[4]


  if (html){
    pro$label = ""
  } else {
    # Add plot labels for best 10 hits within phylum (45%)
    pro$label  <- ""
    if (length(pro$qseqid) >= 10){
      pro$label[1:10] <- pro$sseqid[1:10]
    } else {
      pro$label <- pro$sseqid
    }
    # unassign labels from sub-family match
    pro$label[ which( pro$pident < 45 ) ] <- ""
  }

  idPlot <- ggplot() +
    geom_point(data = pro, aes(uid=sseqid, nick=nickname, seq=seq,
                               x=pident, y=escore, color = matching),
                show.legend = FALSE,
               alpha = 0.75) +
    scale_color_manual(values = rankcols, drop = FALSE) +
    geom_text(data = pro, aes(x=pident, y=escore, label=label),
              color = c("#4D4D4D"),
              hjust = "right", vjust = "bottom", check_overlap = TRUE) +
    geom_vline( xintercept = c(0, 45, 70, 90),
                color = rankcols) +
    ggtitle(label = "Palmprint alignment to palmDB") +
    xlab("Input identity to palmDB (aa%)") + ylab("-log(e-value)") +
    theme(legend.position="none") +
    theme_bw()

  #idPlot

  return(idPlot)
}
