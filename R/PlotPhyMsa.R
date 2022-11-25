# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA 'run_ids' into
#' a geographic world-map and timeline.
#'
#' @param input.msa   msa file
#' @param p phylogeny visualization object. use PlotPhy
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

PlotPhyMsa <- function(input.msa, p) {

    msa_plot <- msaplot(
        p,
        input.msa,
        offset = 0.25,
        bg_line = TRUE,
        color = palette(gray(seq(1, 0, len = 21)))
    ) +
    theme(legend.position = "none")

    return(msa_plot)
}