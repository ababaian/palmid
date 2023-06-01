#' get.palmTax2
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
#' get.palmTax(c("u2", "u1337"), con, rank = "species")
#'
#' @import RPostgreSQL
#' @import dplyr ggplot2
#' @export
get.palmTax2 <- function(palm_ids, con, rank = "family", ordinal = FALSE) {
  # Bind Local Variables
  palm_id <- NULL
  
  # Coerce palm_ids to vector
  if (class(palm_ids) != "character"){
    palm_ids <- as.character(palm_ids)
  }
  
  if ( all( rank == c("tspe", "tfam", "tphy", "gbid", "gbacc")) ){
    rank <- c("tax_species", "tax_family", "tax_phylum", "percent_identity", "gb_acc")
  } else if ( rank == "species" ){
    rank <- "tax_species"
  } else if ( rank == "genus" ){
    rank <- "tax_genus"
  } else if ( rank == "family" ){
    rank <- "tax_family"
  } else if ( rank == "order" ){
    rank <- "tax_order"
  } else if ( rank == "phylum" ){
    rank <- "tax_phylum"
  } else if ( rank == "gbid" ){
    # percent identity of palmprint to GenBank tophit
    rank <- "percent_identity"
  } else if ( rank == "gbacc" ){
    # tophit GenBank accession
    rank <- "gb_acc"
  }
  
  # get sOTU from palm_id
  tax <- tbl(con, "palm_tax") %>%
    dplyr::filter(palm_id %in% palm_ids) %>%
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
    # rename rows by palm_id
    # return rows in order of palm_ids input (ordinal)
    rownames(tax) <- tax$palm_id
    return(tax[palm_ids, -1])
  } else {
    return(unique(tax[, -1]))
  }
}
