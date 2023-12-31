% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fastGrep.R
\name{fastGrep}
\alias{fastGrep}
\title{some fields of interest are lists, and grep per se should not be used -- this function checks and uses grep within vapply when appropriate}
\usage{
fastGrep(patt, onto, field, ...)
}
\arguments{
\item{patt}{a regular expression whose presence in field should be checked}

\item{onto}{an ontologyIndex instance}

\item{field}{the ontologyIndex component to be searched}

\item{\dots}{passed to grep}
}
\value{
logical vector indicating vector or list elements where a match is found
}
\description{
some fields of interest are lists, and grep per se should not be used -- this function checks and uses grep within vapply when appropriate
}
\examples{
cheb = getOnto("chebi_lite")
ind = fastGrep("tanespimycin", cheb, "name")
cheb$name[ind]
}
