#' SerratusConnect
#' 
#' Connection information for reaching the Serratus postgreSQL database
#' See also: https://github.com/ababaian/serratus/wiki/SQL-Schema
#' 
#' @return con PostgreSQLConnection 
#' @keywords palmid Serratus Tantalus postgres
#' @examples
#' con <- SerratusConnect()
#'
#' @export
SerratusConnect <- function(){
  con <- DBI::dbConnect(
    drv = 'PostgreSQL',
    user="public_reader", 
    password="serratus",
    host="serratus-aurora-20210406.cluster-ro-ccz9y6yshbls.us-east-1.rds.amazonaws.com",
    port=5432, 
    dbname="summary")
  return(con)
}
