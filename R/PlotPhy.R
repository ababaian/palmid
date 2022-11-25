# PlotPhy
#' A phylogeny plot wrapper to visualize a phylo object
#' that contains tree tip labels from top-10 hits from palmDB
#' and associated metadata from 'pro.df'
#'
#' @param tree.df   data.frame, merged tree labels and pro.df. use get.proPhy
#' @param tree.phy  phylo object of phylogeny of top-10 hits. use read.phy
#' @return A phylogeny plot with readable tip labels.
#' @keywords dplyr ggplot2 treeio ggtree
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