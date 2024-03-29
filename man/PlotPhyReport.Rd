% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PlotPhyReport.R
\name{PlotPhyReport}
\alias{PlotPhyReport}
\title{A multi-plot wrapper to display a phylogenetic tree of
top-10 hits from palmDB, an MSA plot, and a bar plot of
percentage identity matched.}
\usage{
PlotPhyReport(input.msa, tree.df, tree.phy)
}
\arguments{
\item{input.msa}{msa file path relative to .fev}

\item{tree.df}{data.frame, merged tree labels and pro.df. use get.proPhy}

\item{tree.phy}{phylo object. use read.phy}
}
\value{
A grid-table object. Dimension standard is 800 x 600 px.
}
\description{
A multi-plot wrapper to display a phylogenetic tree of
top-10 hits from palmDB, an MSA plot, and a bar plot of
percentage identity matched.
}
\examples{
data("waxsys.tree.df")
data("waxsys.tree.phy")
data("waxsys.input.msa")

phyReport <- PlotPhyReport(waxsys.input.msa, waxsys.tree.df, waxsys.tree.phy)

}
\keyword{muscle}
\keyword{palmid}
\keyword{phylogeny}
\keyword{tree}
