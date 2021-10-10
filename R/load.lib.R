#' load.lib.R
#' 
#' Internal function to load a set of libraries for palmid functions
#' "geo" is for static maps, "geo2" is for htmlwidget maps
#'
#' @param  lib_set character, one of "sql", "ggplot", "geo", "geo2"
#' @return loads set of packages for functions
#' @keywords palmid serratus sql 
#' @examples
#' 
#' # in an SQL function
#' # load.lib("sql")
#'
#' @import dplyr ggplot2
#' @export
load.lib <- function( lib_set ){
  
  if (lib_set == 'sql'){
    requireNamespace("RPostgreSQL", quietly = T)
    requireNamespace("dplyr", quietly = T)
    requireNamespace("dbplyr", quietly = T)
    
  } else if (lib_set == 'ggplot'){
    requireNamespace("ggplot2", quietly = T)
    requireNamespace("gridExtra", quietly = T)
    requireNamespace("ggplotify", quietly = T)
    requireNamespace("viridisLite", quietly = T)
    requireNamespace("plotly", quietly = T)
    #requireNamespace("ggwordcloud", quietly = T)
    
  } else if (lib_set == 'geo'){
    # Check for suggested packages sf and rnaturalearth
    if (!requireNamespace("sf", quietly = TRUE)) {
      stop("The R Packages 'sf' and 'rnaturalearth' are needed for mapping functionality \n
           and require the system dependency 'libudunits2-dev'.\n
           use 'sudo apt-get install libudunits2-dev' to install",
           call. = FALSE)
    }
    if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
      stop("The R Packages 'sf' and 'rnaturalearth' are needed for mapping functionality \n
           and require the system dependency 'libudunits2-dev'.\n
           use 'sudo apt-get install libudunits2-dev' to install",
           call. = FALSE)
    }
    
    requireNamespace("ggExtra", quietly = T)
    requireNamespace("sf", quietly = T)
    requireNamespace("viridisLite", quietly = T)
    requireNamespace("scales", quietly = T)
    requireNamespace("rnaturalearth", quietly = T)
    requireNamespace("rnaturalearthdata", quietly = T)
    requireNamespace("gridExtra", quietly = T)
    requireNamespace("ggplotify", quietly = T)
    
  } else if (lib_set == 'geo2'){
    
    requireNamespace("ggplot2", quietly = T)
    requireNamespace("ggExtra", quietly = T)
    requireNamespace("plotly", quietly = T)
    requireNamespace("leaflet", quietly = T)
    requireNamespace("htmltools", quietly = T)
    requireNamespace("viridisLite", quietly = T)
    
  } else {
    stop("Error: lib_set should be one of 'sql', 'ggplot', 'geo', or 'geo2'")
  }
}
