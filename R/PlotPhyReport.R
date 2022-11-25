# PlotPhyReport
#' A multi-plot wrapper to display a phylogenetic tree of
#' top-10 hits from palmDB, an MSA plot, and a bar plot of
#' percentage identity matched.
#' 
#'
#' @param input.msa   msa file path relative to .fev
#' @param tree.phy  phylo object. use read.phy
#' @param tree.df   data.frame, merged tree labels and pro.df. use get.proPhy
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid muscle phylogeny tree
#' @examples
#' data("waxsys.pro.df")
#'
#' proTax <- PlotTaxReport( waxsys.pro.df )
#'
#' @import viridisLite
#' @import dplyr ggplot2
#' @export

PlotPhyReport <- function(input.msa, tree.df, tree.phy) {

    # Create phylogeny plot
    PhyPlot <- PlotPhy(tree.df, tree.phy)
    
    # Create bar plot
    PhyBarPlot <- PlotPhyBar(tree.df, PhyPlot)

    # Create MSA plot 
    PhyMsaPlot <- PlotPhyMsa(input.msa, PhyPlot)

    # Create a grid
    PalmPhy <- gridExtra::arrangeGrob(
        PhyPlot,
        PhyBarPlot,
        PhyMsaPlot,
        layout_matrix = rbind(c(1, 2),c(3, 3))
    )

    return(PalmPhy)
}
