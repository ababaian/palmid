# PlotPhyMsa
#' A multi-plot wrapper to generate an MSA plot from input.msa and
#' align it with a phylogenetic tree plot.
#'
#' @param input.msa   msa file path relative to .fev
#' @param p phylogeny visualization object. use PlotPhy
#' @return A single object consisting of two facets for tree and MSA
#' @keywords dplyr ggplot2 treeio ggtree msa
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
    requireNamespace("ggtree", quietly = T)

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