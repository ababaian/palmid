#' PlotTimeline
#' Create a timeline of data-releases in palm.sra
#'
#' @param palm.sra data.frame, created with get.palmSra(pro.df, con)
#' @param html boolean, generate htmlWidget instead of ggplot [TRUE]
#' @return ggplot2, timeline of SRA load dates
#' @keywords palmid timeline
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export
# Retrieve date from input of sra run_ids
PlotTimeline <- function(palm.sra, html = TRUE){
  
  # Bind Local Variables
  setNames <- colr <- NULL
  
  # Color pallette
  ranklvl   <-  c("phylum",  "family",  "genus",   "species")
  rankcols  <-  c("#9f62a1", "#00cc07", "#ff9607", "#ff2a24")
  
  rankdraw <- setNames(c("#9f62a1", "#00cc07", "#ff9607", "#ff2a24"),
                       c("phylum",  "family",  "genus",   "species"))

  palm.sra$rank <- ranklvl[1]
  palm.sra$colr <- rankcols[1]
  
  palm.sra$rank[palm.sra$pident >= 45] <- ranklvl[2]
  palm.sra$colr[palm.sra$pident >= 45] <- rankcols[2]
  
  palm.sra$rank[palm.sra$pident >= 70] <- ranklvl[3]
  palm.sra$colr[palm.sra$pident >= 70] <- rankcols[3]
  
  palm.sra$rank[palm.sra$pident >= 90] <- ranklvl[4]
  palm.sra$colr[palm.sra$pident >= 90] <- rankcols[4]
  
  
  if (html) {
  timeline <- plotly::plot_ly(x = palm.sra$date[ palm.sra$rank == 'species'],
                      color = ranklvl[4], colors = rankdraw,
                      type = 'histogram', bingroup = 1,
                      nbinsx  = 120,
                      xbins = list( start = as.POSIXct("2010-01-01"),
                                    end   = as.POSIXct("2021-01-02"))) %>%
    plotly::add_trace(x = palm.sra$date[ palm.sra$rank == 'genus'],
                        color = ranklvl[3],
                      type = 'histogram', bingroup = 1) %>%
    plotly::add_trace(x = palm.sra$date[ palm.sra$rank == 'family'],
                        color = ranklvl[2],
                        type = 'histogram', bingroup = 1) %>%
    plotly::add_trace(x = palm.sra$date[ palm.sra$rank == 'phylum'],
                        color = ranklvl[1],
                        type = 'histogram', bingroup = 1) %>%
    plotly::layout(barmode = "overlay", bargap = 0.1,
           yaxis = list( title = 'SRA count'),
           xaxis = list( title = 'release date',
                         autorange = TRUE,
                         range = list( as.POSIXct( c("2010-01-01","2021-01-02") )))) %>%
    plotly::config(displaylogo = FALSE)
  
  } else {
  timeline <- ggplot( palm.sra, aes(date, fill = colr)) +
    geom_histogram(bins = 120) +
    scale_fill_identity() +
    scale_x_datetime(date_breaks = "2 years",
                     date_minor_breaks = "1 month",
                     date_labels = "%Y",
                     limits = as.POSIXct( c("2010-01-01","2021-01-02")) ) +
    xlab("Run release date") + ylab("runs") +
    #facet_wrap(ncol = 1, scales = "free_y", ~rank) +
    theme_classic()
  }
  
  return(timeline)
  
}
