# make_bg_data
#' Read a multiple-FEV file to create a background set of palmprints
#' Standard approach is to use palmDB
#' @param fev.path Path to multiple fev file
#' @param dataset.id Name for output dataset.
#' @param return.data  Boolean. Return data.frame instead of writing file [TRUE]
#' @return NULL: will write an RData file to data/<fev.path>.RData
#' @keywords palmid palmdb palmprints
#' @examples
#' 
#' #' # palmscan example fev file
#' ps.fev.path <- system.file( "extdata", "waxsys.fev", package = "palmid")
#' example_bg <- make_bg_data(fev.path = ps.fev.path, dataset.id = 'example_bg')
#' 
#' ## Documentation on Making Background Dataset from palmDB
#' ##  i.e. load("palmdb")
#' ## 
#' ## Download palmDB to make background set
#' # system("git clone https://github.com/rcedgar/palmdb.git")
#' #
#' ## Generate the palmprint-FEV with palmscan
#' # system("palmscan -search_pp palmdb/2021-03-02/otu_centroids.fa \
#' #         -all -rdrp -fevout data/palmdb210302.fev")
#' #
#' ## Create R object (data.frame)
#' # make_bg_data(fev.path = "data/palmdb210302.fev",
#' #              dataset.it = "palmdb",
#' #              return.data = FALSE)
#' #
#' # load("palmdb")
#'
#' @import dplyr ggplot2
#' @export
make_bg_data <- function(fev.path, dataset.id = NULL, return.data = TRUE) {
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

  #bg.fev <- bg.fev[, c("score", "pssm_total_score", "pp_length", "v1_length", "v2_length")]

  rdata.path <- paste0("data/", dataset.id, ".Rdata")
  
  if (return.data){
    return( dataset.id )
  } else  {
    save( list = dataset.id, file = rdata.path)
  }

  

}