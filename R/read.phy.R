# read.pro
#' Reads a .pro file created by 'diamond'
#' @param pro.path relative system path to .fev file
#' @return A diamond-pro data.frame object
#' @keywords palmid diamond pro
#' @examples
#' # palmDB Alignment file (.pro)
#' pro.path <- system.file( "extdata", "waxsys.pro", package = "palmid")
#' pro.df <- read.pro(pro.path)
#'
#' @import dplyr ggplot2 ggtree
#' @export
read.phy <- function(input.phy) {
    requireNamespace("ggtree", quietly = T)

    tree.phy <- read.tree(input.phy)
    return(tree.phy)
}