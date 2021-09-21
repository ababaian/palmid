# PlotGeo
#' A multi-plot wrapper to convert a list of SRA `run_ids` into
#' a geographic world-map and timeline.
#' 
#' @param run_ids character, vector of SRA run_id
#' @param con      pq-connection, use SerratusConnect()
#' @return A grid-table object. Dimension standard is 800 x 600 px.
#' @keywords palmid sql geo timeline Serratus Tantalus
#' @examples
#' 
#' geoSRA <- PlotGeoReport( XXX )
#'
#' @export
PlotGeo <- function(run_ids, con = SerratusConnect()){
  load.lib("geo")
  
  # Count unique input run_ids
  run_ids <- unique(run_ids)
  n.sra <- length(run_ids)
  n.geo <- 0
  
  # Convert run_ids into corresponding geo data via biosample_id intermediate
  # run_id --> biosample_id
  pp.bs  <- get.sraBio(run_ids, con = con)
    pp.bs <-  unique(as.character(pp.bs$biosample_id))
  
  # Static (sf) Version ---------------------------------
  
  # biosample_id --> geo_coordinates.df (and filter)
  pp.geo <- get.sraGeo(palm.usra, con = con)
  pp.geo <- geoFilter(pp.geo, wobble = F)
    n.geo  <- length(pp.geo[,1])
    nn.stat <- paste0("geo-data for ", n.geo, " / ", n.sra," runs retrieved")
  
  # Map pallete-set
  rdrp_dark <- c('black',  'gray5', 'gray10', 'gray20')
  rdrp_lite <- c('white',   NA,   'gray70', 'gray95')
  rdrp_col <- rdrp_lite
  
  # Plot Worldmap
  world <- ne_countries(scale = "medium", returnclass = "sf")
  ggplot() + geom_sf(data = world) + theme_bw()
  
  # Overlay worldmap with hex plot and summary stats
  earth <- ggplot(data = world) +
    geom_sf(fill = rdrp_col[1], color = rdrp_col[2]) +
    xlab('') + ylab('') +
    ggtitle("Global Palmprint Distribution") + 
    theme(panel.background = element_rect( fill = rdrp_col[3]),
          panel.grid.major = element_line(color = rdrp_col[4],
                                          linetype = 'dashed',
                                          size = 0.2)) +
    # Summary statistic for SQL retrival
    geom_text( data = data.frame(nn.stat),
               x = Inf, y = -Inf,
               hjust = "inward", vjust = "inward",
               color = 'black', size = 5, label = nn.stat) +
    # Hex points of available data
    geom_hex( bins = 36, data = pp.geo,
              aes(x = lng, y = lat)) +
    scale_fill_continuous(name = 'runs/point', 
                          type = "viridis", option = "plasma", trans = "log2")
  
  return(earth)
}
