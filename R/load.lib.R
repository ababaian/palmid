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
#' load.lib("sql")
#'
#' @export
load.lib <- function( lib_set ){
  
  if (lib_set == 'sql'){
    require("RPostgreSQL", quietly = T)
    require("dplyr", quietly = T)
    require("dbplyr", quietly = T)
    
  } else if (lib_set == 'ggplot'){
    require("ggplot2", quietly = T)
    require("gridExtra", quietly = T)
    require("ggplotify", quietly = T)
    require("viridisLite", quietly = T)
    require("plotly", quietly = T)
    #require("ggwordcloud", quietly = T)
    
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
    
    require("ggExtra", quietly = T)
    require("sf", quietly = T)
    require("viridisLite", quietly = T)
    require("scales", quietly = T)
    require("rnaturalearth", quietly = T)
    require("rnaturalearthdata", quietly = T)
    require("gridExtra", quietly = T)
    require("ggplotify", quietly = T)
    
  } else if (lib_set == 'geo2'){
    
    require("ggplot2", quietly = T)
    require("ggExtra", quietly = T)
    require("plotly", quietly = T)
    require("leaflet", quietly = T)
    require("htmltools", quietly = T)
    require("viridisLite", quietly = T)
    
  } else {
    stop("Error: lib_set should be one of 'sql', 'ggplot', 'geo', or 'geo2'")
  }
}
