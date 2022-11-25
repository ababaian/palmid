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
#' @import Biostrings dplyr ggplot2 treeio ggtree ggmsa
#' @export

PlotPhyMsa <- function(input.msa, p) {
    requireNamespace("ggmsa", quietly = T)

    aa_string <- readAAStringSet(input.msa)
    
    taxa_order = get_taxa_name(p)
    aa_df <- data.frame(
        width = width(aa_string),
        seq = as.character(aa_string),
        names = names(aa_string)
    ) %>% arrange(factor(names, levels = taxa_order))

    aa_set <- AAStringSet(aa_df$seq)
    names(aa_set) = aa_df$names

    phy_msa_plot <- p + 
        geom_facet(
            geom = geom_msa, 
            data = tidy_msa(aa_set),
            panel = 'Multiple Sequence Alignment',
            color = "Taylor_AA",
            char_width = 0,
            border = "white",
            show.legend = TRUE
        ) +
        guides(fill = guide_legend(title = NULL)) +
        theme(legend.position = "bottom")

    return(phy_msa_plot)
}