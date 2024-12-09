% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/owl_ops.R
\name{ancestors}
\alias{ancestors}
\title{retrieve ancestor 'sets'}
\usage{
ancestors(oe)
}
\arguments{
\item{oe}{owlents instance}
}
\value{
a list of sets
}
\description{
retrieve ancestor 'sets'
}
\examples{
pa = get_ordo_owl_path()
o2 = try(reticulate::import("owlready2"), silent=TRUE)
if (!inherits(o2, "try-error")) {
 orde = setup_entities(pa)
 orde
 ancestors(orde[1:5])
 labels(orde[1:5])
}
}
