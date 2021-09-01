# make_bg_data
#' Read a multiple-FEV file to create a background set of palmprints
#' Standard approach is to use palmDB 
#' @param fev.path Path to multiple fev file
#' @return NULL: will write an RDS file to <fev.path>.RDS
#' @keywords palmid palmdb palmprints
#' @examples
#' # Download palmDB to make background set on
#' system("git clone https://github.com/rcedgar/palmdb.git")
#' # Generate FEV with palmscan
#' system("palmscan -search_pp palmdb/2021-03-02/otu_centroids.fa -all -rdrp -fevout R/palmdb210302.fev")
#' # Create R object (data.frame)
#' make_bg_data(R/palmdb210302.fev)
#' @export
make_bg_data <- function(fev.path) {
  # Read a multiple-FEV file from palmscan
  # to create a background dataset of RdRP statistics
  # - palmprint lengths
  # - Total scores
  # - motif scores (NA)
  
  bg.fev <- read.fev(fev.path)
  
  #bg.fev <- bg.fev[, c('score', 'pssm_total_score', 'pp_length', 'v1_length', 'v2_length')]
  
  rdata.path <- paste0(fev.path, ".RDS")
  
  saveRDS(bg.fev, rdata.path)
}
## Make background data-set (run once)
#fev.path <- 'R/palmdb210302.fev'
#make_bg_data(fev.path)
#pp.bg <- readRDS(paste0( fev.path, '.RDS') )