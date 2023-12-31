#' dropStop is a utility for removing certain words from text data
#' @param x character vector of strings to be cleaned
#' @param drop character vector of words to scrub
#' @param lower logical, if TRUE, x converted with \code{\link{tolower}}
#' @param splitby character, used with strsplit to tokenize \code{x}
#' @return a list with one element per input string, split by " ", with elements in \code{drop} removed
#' @examples
#' data(minicorpus)
#' minicorpus[1:3]
#' dropStop(minicorpus)[1:3]
#' @export
dropStop = function(x, drop, lower=TRUE, splitby=" ") {
 if (missing(drop)) {
#    stopWords <- NULL
    data("stopWords", package="ontoProc")
    drop = stopWords
    }
 tx = force
 if (lower) tx = tolower
 spl = strsplit(tx(x), splitby)
 lapply(spl, setdiff, drop)
}
