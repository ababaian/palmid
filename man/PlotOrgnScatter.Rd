% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PlotOrgnScatter.R
\name{PlotOrgnScatter}
\alias{PlotOrgnScatter}
\title{Plot a scatter-plot of the organisms in a palm.sra object or orgn.vec}
\usage{
PlotOrgnScatter(palm.sra = NULL, orgn.vec = NULL)
}
\arguments{
\item{palm.sra}{data.frame, created from get.palmSra() [NULL]}

\item{orgn.vec}{character, vector of "scientific_name" from sra run table [NULL]}
}
\value{
A ggwordcloud object of the "ntop" frequent terms
}
\description{
Plot a scatter-plot of the organisms in a palm.sra object or orgn.vec
}
\examples{

# Retrive organism identifiers from SRA Run Info Table
# palm.orgn <- get.sraOrgn(run_ids, con)

# Load Waxsystermes Exampel data
data("waxsys.palm.sra")

# Create wordcloud of organism terms
# using column "scientific_name" in data.frame

# Scaled by frequency of organism term in all of data.frame
PlotOrgn( waxsys.palm.sra )

# Scaled by proximity of organism tag to input sequence (pident)
PlotOrgn( waxsys.palm.sra , freq = FALSE)

}
\keyword{palmid}
\keyword{plot}
\keyword{pro}
