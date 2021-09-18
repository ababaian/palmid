#' load.lib.R
#' 
#' Internal function to load a set of libraries for palmid functions
#'
#' @param  lib_set character, one of "sql", "ggplot", "geo"
#' @return loads set of packages for functions
#' @keywords palmid serratus sql 
#' @examples
#' 
#' # in an SQL function
#' load.lib("sql")
#'
#' 'export
load.lib <- function( lib_set ){
  
  if (lib_set == 'sql'){
    require("RPostgres", quietly = T)
    require("dplyr", quietly = T)
    require("dbplyr", quietly = T)
    
  } else if (lib_set == 'ggplot'){
    require("ggplot2", quietly = T)
    require("gridExtra", quietly = T)
    require("ggplotify", quietly = T)
    require("viridisLite", quietly = T)
    #require("ggwordcloud", quietly = T)
    
  } else if (lib_set == 'geo'){
    require("ggExtra", quietly = T)
    require("sf", quietly = T)
    require("viridisLite", quietly = T)
    require("scales", quietly = T)
    require("rnaturalearth", quietly = T)
    require("rnaturalearthdata", quietly = T)
    require("gridExtra", quietly = T)
    require("ggplotify", quietly = T)
    
  } else {
    stop("Error: lib_set should be one of 'sql', 'ggplot', or 'geo'")
  }
}
