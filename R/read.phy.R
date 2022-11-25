# read.pro
#' Reads a .phy file generated from muscle
#' @param phy.path relative system path to .fev file
#' @return A phylo object
#' @keywords palmid muscle phylogeny tree
#' @examples
#' # palmDB Tree file (.phy)
#' phy.path <- system.file( "extdata", "waxsys.phy", package = "palmid")
#' tree.phy <- read.phy(phy.path)
#'
#' @import ggtree
#' @export

read.phy <- function(phy.path) {
    requireNamespace("ggtree", quietly = T)

    tree.phy <- read.tree(phy.path)
    return(tree.phy)
}