# get.proPhy
#' A wrapper for get.palmTax() specific for 'pro.df' input
#' and returns a populated the "tspe", "tfam", and "tphy"
#' columns of 'pro.df' based on the "sseqid" column
#'
#' @param pro.df   data.frame, imported diamond pro df. use get.pro()
#' @param con      pq-connection, use SerratusConnect()
#' @return pro.df  data.frame
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#'
#' ## Prepare data
#' # data("waxsys.pro.df")
#' # con <- SerratusConnect()
#'
#' ## Generate Report
#' # geoSRA <- PlotGeoReport( waxsys.pro.df )
#'
#'
#' @import dplyr ggplot2 treeio ggtree
#' @export
#'
#' 

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