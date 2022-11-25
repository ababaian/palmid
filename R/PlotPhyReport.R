# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA 'run_ids' into
#' a geographic world-map and timeline.
#'
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
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

    PalmPhy <- gridExtra::arrangeGrob(
        PhyPlot,
        PhyBarPlot,
        PhyMsaPlot,
        layout_matrix = rbind(c(1, 2),c(3, 3))
    )

    return(PalmPhy)
}
