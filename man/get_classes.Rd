% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/owl_ops.R
\name{get_classes}
\alias{get_classes}
\title{return a generator with ontology classes}
\usage{
get_classes(owlfile)
}
\arguments{
\item{owlfile}{reference to OWL file, can be URL, will be processed
by owlready2.get_ontology}
}
\value{
generator with output of classes() on the loaded ontology
}
\description{
return a generator with ontology classes
}
