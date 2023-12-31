% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/owl_ops.R
\name{labels.owlents}
\alias{labels.owlents}
\title{retrieve labels with names}
\usage{
\method{labels}{owlents}(object, ...)
}
\arguments{
\item{object}{owlents instance}

\item{\dots}{not used}
}
\description{
retrieve labels with names
}
\note{
When multiple labels are present, only first is silently returned.
To get ontology tags, use `names(labels(...))`.
}
