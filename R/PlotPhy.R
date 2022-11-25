# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA 'run_ids' into
#' a geographic world-map and timeline.
#'
#' @param tree.df   data.frame, merged tree labels and pro. use get.proPhy()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' data("waxsys.pro.df")
#'
#' proTax <- PlotTaxReport( waxsys.pro.df )
#'
#' @import viridisLite
#' @import dplyr ggplot2 treeio ggtree
#' @export

PlotPhy <- function(tree.df, tree.phy) {
    requireNamespace("ggtree", quietly = T)

    # Plot tree with tip labels
    p <- ggtree(tree.phy) %<+% tree.df +
        hexpand(0.3) +
        geom_label(aes(label=ifelse(is.na(sseqid), nickname, paste0(sseqid, " (", nickname, ")"))))

   return(p)
}