# get.proPhy
#' Merges 'pro.df' with 'tree.phy'
#' to add annotations from palmDB to the phylogenetic tree object.
#' Returns a data frame containing tree tip labels and palmDB columns
#'
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @param tree.phy  phylo object. use read.phy
#' @return tree.df  data.frame
#' @keywords palmid muscle phylogeny tree
#' @examples
#'
#' ## Prepare data
#' # data("waxsys.pro.df")
#' # phy.path <- system.file( "extdata", "waxsys.phy", package = "palmid")
#' # waxsys.phy <- read.phy(phy.path)
#'
#' ## Generate tree data frame
#' # tree.df <- get.proPhy(waxsys.pro.df, waxsys.phy)
#'
#'
#' @import dplyr ggplot2 treeio ggtree
#' @export

get.proPhy <- function(pro.df, tree.phy) {

    # Create a data frame based on the tree phylo object
    tree.phy.df <- data.frame(label = tree.phy$tip.label)

    # Format pro.df to have a tip.label column like tree
    pro.df$label <- paste0(pro.df$sseqid, "_", sprintf(pro.df$pident, fmt = "%#.1f")) 

    tree.df <- merge(x = tree.phy.df, y = pro.df, by = "label", all.x = TRUE)

    # Clean NA values in tspe and nickname columns
    tree.df$tspe[is.na(tree.df$tspe) | tree.df$tspe == "."] <- "Unclassified"
    tree.df$nickname[is.na(tree.df$nickname)] <- tree.df$label

    return(tree.df)
}