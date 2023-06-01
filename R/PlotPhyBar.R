# PlotPhyBar
#' A plot wrapper to generate a horizontal bar plot
#' of input identity to palmDB (aa%).
#' The order of the bars matches the taxa order
#' of the phylogenetic tree object tree.phy
#'
#' @param tree.df   data.frame, merged tree labels and pro.df. use get.proPhy
#' @param p  a ggtree plot of tree.phy. use PlotPhy
#' @return A bar plot of % input identity to palmDB
#' @keywords dplyr ggplot2 treeio ggtree
#' @examples
#' data("waxsys.tree.df")
#' data("waxsys.tree.phy")
#' p <- PlotPhy(waxsys.tree.phy)
#' plotPhyBar <- PlotPhyBar(waxsys.tree.df, p)
#'
#' @import viridisLite
#' @import dplyr ggplot2 treeio ggtree
#' @export

PlotPhyBar <- function(tree.df, p) {
    requireNamespace("ggtree", quietly = T)

    # Assign classification
    tree.df2 <- tree.df %>% 
        mutate(classify = case_when(pident == 100 ~ "input",
                                    pident <100  & pident >= 90 ~ "species",
                                    pident >= 70 & pident < 90 ~ "genus",
                                    pident >= 45 & pident < 70 ~ "family",
                                    pident < 45 ~ "phylum"))

    # Obtain taxa order of tree
    taxa_order = get_taxa_name(p)

    # Order rows of dataframe the same as phylogeny taxa order
    tree.df2$label <- factor(tree.df$label, levels=rev(taxa_order))
    
    # Label input node
    tree.df2$pident[1]   <- 100
    tree.df2$classify[1] <- 'input'
    
    # Add GenBank labels with percent alignment id
    tree.df2$gblabel <- paste0( tree.df2$tspe, " (", tree.df2$gbid, "%)")

    bar_plot <- ggplot(
            tree.df2,
            mapping = aes(x = pident, y = label, fill = classify),
        ) +
        ggtitle("Alignment identity vs.palmDB & GB-taxa top-hit (aa%)") +
        geom_bar(stat="identity") +
        geom_text(
            aes(
            label = gblabel, 
            x = 1.25, 
            hjust = 'left'
            ), 
            stat = "identity", 
            color = "gray90",
            fontface = "bold"
        ) +
        scale_fill_manual(values = c(
            "phylum" = "#9f62a1",
            "family" = "#00cc07",
            "genus" = "#ff9607",
            "species" = "#ff2a24",
            "input"  = "#000000"
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
        geom_vline(xintercept = 45, color = "#00cc07", alpha = 0.5, linewidth=0.75) + 
        geom_vline(xintercept = 70, color = "#ff9607", alpha = 0.5, linewidth=0.75) +
        geom_vline(xintercept = 90, color = "#ff2a24", alpha = 0.5, linewidth=0.75) +
        xlab(NULL)
    phy_bar_plot <- p + bar_plot

    return(phy_bar_plot)
}
