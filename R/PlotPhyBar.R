# PlotTaxReport
#' A multi-plot wrapper to convert a list of SRA 'run_ids' into
#' a geographic world-map and timeline.
#'
#' @param tree.df   data.frame, merged tree labels and pro. use get.proPhy()
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


PlotPhyBar <- function(tree.df, p) {
    requireNamespace("ggtree", quietly = T)

    # Assign classification
    tree.df <- tree.df %>% 
        mutate(classify = case_when(pident >= 90 ~ "species",
                                    pident >= 70 & pident < 90 ~ "genus",
                                    pident >= 45 & pident < 70 ~ "family",
                                    pident < 45 ~ "phylum"))

    # Obtain taxa order of tree
    taxa_order = get_taxa_name(p)

    # Order rows of dataframe the same as phylogeny taxa order
    tree.df$label <- factor(tree.df$label, levels=rev(taxa_order))

    bar_plot <- ggplot(
            tree.df,
            mapping = aes(x = pident, y = label, fill = classify),
        ) + 
        geom_bar(stat="identity") +
        geom_text(
            aes(
            label = tspe, 
            x = 1.25, 
            hjust = 'left'
            ), 
            stat = "identity", 
            color = "white",
            fontface = "bold"
        ) +
        scale_fill_manual(values = c(
            "phylum" = "#9f62a1",
            "family" = "#00cc07",
            "genus" = "#ff9607",
            "species" = "#ff2a24"
        ), name = "") +
        scale_x_continuous(limits = c(0,110), expand = c(0, 0)) +
        theme_bw() +
        theme(
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            axis.title.y=element_blank(),
            panel.border=element_blank()
        ) +
        theme(
            axis.line.x.bottom = element_line()
        ) +
        geom_vline(xintercept = 45, color = "#00cc07", size=0.75) + 
        geom_vline(xintercept = 70, color = "#ff9607", size=0.75) +
        geom_vline(xintercept = 90, color = "#ff2a24", size=0.75) + 
        xlab("Input Identity to PalmDB (aa%)")
    
    return(bar_plot)
}