# make_bg_data
#' Read a multiple-FEV file to create a background set of palmprints
#' Standard approach is to use palmDB 
#' @param fev.path Path to multiple fev file
#' @param dataset.id Name for output dataset.
#' @return NULL: will write an Rdata file to data/<fev.path>.Rdata
#' @keywords palmid palmdb palmprints
#' @examples
#' # Download palmDB to make background set on
#' system("git clone https://github.com/rcedgar/palmdb.git")
#' # Generate FEV with palmscan
#' system("palmscan -search_pp palmdb/2021-03-02/otu_centroids.fa \
#'         -all -rdrp -fevout data/palmdb210302.fev")
#' # Create R object (data.frame)
#' make_bg_data(data/palmdb210302.fev, dataset.it = 'palmdb')
#' @export
make_bg_data <- function(fev.path, dataset.id = NULL) {
  # Read a multiple-FEV file from palmscan
  # to create a background dataset of RdRP statistics
  # - palmprint lengths
  # - Total scores
  # - motif scores (NA)
  
  # If dataset.id is unused, use fev-name as the variable name
  if (is.null(dataset.id)) {
    # strip leading path directory
    dataset.id <- gsub(".*/","", fev.path)
    print( paste0("Creating background dataset as ,", dataset.id))
  }
  
  print( paste0("Creating background dataset as: ", dataset.id))
  print( paste0("  saved as: data/", dataset.id, ".Rdata"))
  
  assign(dataset.id, read.fev(fev.path))
  
  #bg.fev <- bg.fev[, c('score', 'pssm_total_score', 'pp_length', 'v1_length', 'v2_length')]
  
  rdata.path <- paste0("data/", dataset.id, ".Rdata")
  
  save( list = dataset.id, file = rdata.path)
}
## Make background data-set (run once)
#fev.path <- 'R/palmdb210302.fev'
#make_bg_data(fev.path)
#pp.bg <- readRDS(paste0( fev.path, '.RDS') )