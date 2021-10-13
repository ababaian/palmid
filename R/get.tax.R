#' get.tax
#'
#' Retrieve the taxonomic identifiers for a set of 'palm_id'
#' for a given rank.
#'
#' @param palm_ids character, set of 'palm_id' to lookup in palmdb
#' @param con      pq-connection, use SerratusConnect()
#' @param rank     character, taxonomic rank to retrieve. One of
#'     "species", "genus", "family" (Default), "phylum"
#' @param ordinal  boolean, return an ordered vector based on input 'palm_ids'
#' @return character, unique 'tax_id' vector (i.e. "Coronaviridae")
#' @keywords palmid palmdb taxonomy
#' @examples
#' con <- SerratusConnect()
#'
#' # Return species-identifiers for a set of palmprints (uxxx)
#' get.tax(c("u2", "u1337"), con, rank = "species")
#'
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
get.tax <- function(palm_ids, con, rank = "family", ordinal = FALSE) {
  # Bind Local Variables
  palm_id <- NULL

  # Coerce palm_ids to vector
  if (class(palm_ids) != "character"){
    palm_ids <- as.character(palm_ids)
  }

  if ( rank == "species" ){
    rank <- "tax_species"
  } else if ( rank == "genus" ){
    rank <- "tax_genus"
  } else if ( rank == "family" ){
    rank <- "tax_family"
  } else if ( rank == "phylum" ){
    rank <- "tax_phylum"
  }

  # get sOTU from palm_id
  tax <- tbl(con, "palmdb") %>%
    filter(palm_id %in% palm_ids) %>%
    select(palm_id, !!rank) %>%
    as.data.frame()

  colnames(tax) <- c("palm_id", eval(rank))

  # Bit of a sloppy check here
  if ( length(tax$palm_id) == 0 ){
    stop(paste0(palm_ids, " did not return a valid palm_id."))

  } else if ( length(tax$palm_id) != length(palm_ids)){
    warning("Warning: One or more of the input palm_ids were not retrieved.")
  }

  if (ordinal){
    return(tax[, 2])
  } else {
    return(unique(tax[, 2]))
  }
}
