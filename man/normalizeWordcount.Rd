% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalizeWordCount.R
\name{normalizeWordcount}
\alias{normalizeWordcount}
\title{normalizeWordCount
Create frequency-count table from a set of characters
which are normalized as percentage of total corpus}
\usage{
normalizeWordcount(words, ntop = 50, logTwo = FALSE)
}
\arguments{
\item{words}{character, description of vector [Default]}

\item{ntop}{numeric,   return only N top words [50]}

\item{logTwo}{boolean,   apply a log2 transformation [FALSE]}
}
\value{
table, frequency-count table
}
\description{
normalizeWordCount
Create frequency-count table from a set of characters
which are normalized as percentage of total corpus
}
\keyword{palmid}
\keyword{plot}
\keyword{wordcloud}
