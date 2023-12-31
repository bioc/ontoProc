
# recurse along chain of CL: tokens found in 'intersection_of' element 
# of CL entry x
# return initial entry along with intersection components
intchain = function(ont, x, nlink=30, rec=NULL) {
 z = ont$intersection_of[[x]]
 if (!is.character(z)) return(rec)
 nxt = grep("CL:", z, value=TRUE)[1]
 if (is.na(nxt)) return(rec)
 rec = c(rec, nxt)
 if (nlink==0) {
   message(sprintf("exceeded nlink (%d) searches\n", nlink))
   return(rec)
   }
 nlink = nlink-1
 Recall(ont, nxt, nlink, rec)
}

isachain = function(ont, x, nlink=30, rec=NULL) {
 z = ont$is_a[[x]]
 if (!is.character(z)) return(rec)
 nxt = grep("CL:", z, value=TRUE)[1]
 if (is.na(nxt)) return(rec)
 rec = c(rec, nxt)
 if (nlink==0) {
   message(sprintf("exceeded nlink (%d) searches\n", nlink))
   return(rec)
   }
 nlink = nlink-1
 Recall(ont, nxt, nlink, rec)
}

#' enumerate ontological relationships used in ontoProc utilities
#' @return character vector, names of elements are abbreviated tokens that may be used in code
#' @examples
#' head(recognizedPredicates())
#' @export
recognizedPredicates = function() {
 c(hasPMP="has_plasma_membrane_part",
   lacksPMP="lacks_plasma_membrane_part",
   hiPMAmt="has_high_plasma_membrane_amount",
   loPMAmt="has_low_plasma_membrane_amount", 
   hasPart="has_part", 
   lacksPart="lacks_part",
   hasExp="has_expression_of",
   lacksExp="lacks_expression_of")
}
      

CLfeat = function(ont, curtag="CL:0001054", prefix="^CL", 
   preds=recognizedPredicates(), pr, go, ...) {
# require(dplyr)
# require(magrittr)
# require(ontoProc)
 kpl = lapply(preds, function(x)
         which(sapply(ont[[x]], length)>0))
 kp = unique(unlist(kpl))
 clClassNames = sort(ont$name[kp])
 clClassDF = data.frame(tag=names(clClassNames), 
    text=as.character(clClassNames), stringsAsFactors=FALSE)
 clCL = clClassDF %>% dplyr::filter(grepl(prefix, tag))
 prOrGO_OLD = function(x) na.omit(c(
      pr$name[x], go$name[x]))
 prOrGO = function(x) {
    mp = function(z) if (substr(z,1,2)=="GO") go$name[z] else if (substr(z,1,2)=="PR") pr$name[z] else NA
    sapply(x, mp)
 }
 ac = as.character
 recpred = ac(recognizedPredicates())
 dflist = lapply(recpred, function(x)
     data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE))
 names(dflist) = recpred
 #print(dflist)
  #
# lackdf = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)
# hasdf = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)
# lackdfa = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)
# hasdfa = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)
# haspardfa = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)
# lackspardfa = data.frame(tag="", prtag="", cond="", entity="", stringsAsFactors=FALSE)

 fromOnt = lapply(recpred, function(x) ont[[x]][[curtag]])
 names(fromOnt) = recpred

# DO WE NEED THIS?
 #intdata = ont$intersection_of[[curtag]]
 #if (length(intdata)==0) {
 #  message(paste("no intersection information for", curtag))
 #  return(NULL)
 #  }

# hasp = ont$has_plasma_membrane_part[[curtag]]
# lacksp = ont$lacks_plasma_membrane_part[[curtag]]
# haspa = ont$has_high_plasma_membrane_amount[[curtag]]
# lackspa = ont$has_low_plasma_membrane_amount[[curtag]]
# haspar = ont$has_part[[curtag]]
# lackspar = ont$lacks_part[[curtag]]

 nRecRefs = sum(sapply(fromOnt, length))
 if (nRecRefs < 1) {
   message(paste("no recognized predicate references for", curtag))
   return(NULL)
   }

# nPMrefs = sum(sapply(list(hasp,lacksp,haspa,lackspa,haspar,
#      lackspar),length))
# if (nPMrefs<1) {
#   message(paste("no plasma membrane/part condition references for", curtag))
#   return(NULL)
#   }
#
# only part references to resolve are in either PR or GO
#
# prgoParts = grep("^PR|^GO", haspar)
# useParts = TRUE
# if (length(prgoParts)<1) useParts=FALSE
# if (useParts) haspar = haspar[prgoParts]
#
# prgoPartsL = grep("^PR|^GO", lackspar)
# usePartsL = TRUE
# if (length(prgoPartsL)<1) usePartsL=FALSE
# if (usePartsL) lackspar = lackspar[prgoPartsL]

i = curtag
numdf = length(dflist)
dfl = lapply(1:numdf, function(x) {
        curpred = ac(names(dflist))[x]
        rp = recognizedPredicates()
        extract = fromOnt[[curpred]]
        if (length(extract)>0)
             dflist[[curpred]] = data.frame(tag=i, prtag=extract,
                       cond=names(rp)[x], entity=prOrGO(extract), stringsAsFactors=FALSE)
        })

# if (length(hasp)>0) hasdf = data.frame(tag=i,
#                              prtag=hasp, cond="hasPMPart", entity=prOrGO(hasp), stringsAsFactors=FALSE)
# if (length(lacksp)>0) lackdf = data.frame(tag=i,
#                              prtag=lacksp, cond="lacksPMPart", entity=prOrGO(lacksp), stringsAsFactors=FALSE)
# if (length(haspa)>0) hasdfa = data.frame(tag=i,
#                              prtag=haspa, cond="highPMAmt", entity=prOrGO(haspa), stringsAsFactors=FALSE)
# if (length(lackspa)>0) lackdfa = data.frame(tag=i,
#                              prtag=lackspa, cond="lowPMAmt", entity=prOrGO(lackspa), stringsAsFactors=FALSE)
# if (length(haspar)>0 && useParts) haspardfa = data.frame(tag=i,
#                              prtag=haspar, cond="hasPart", entity=prOrGO(haspar), stringsAsFactors=FALSE)
# if (length(lackspar)>0 && usePartsL) lackspardfa = data.frame(tag=i,
#                              prtag=lackspar, cond="lacksPart", entity=prOrGO(lackspar), stringsAsFactors=FALSE)
prupdate = function(x) {
   data("PROSYM", package="ontoProc")
   if (is.null(x) || !inherits(x, "data.frame") || nrow(x)<1) return(x)
   try(left_join(x, dplyr::transmute(PROSYM, prtag=PRID, SYMBOL), by="prtag"))
}
ans = lapply(dfl, prupdate)
lkta = lapply(ans, function(x) x$tag[1])
if (all(lkta=="")) { message("no properties resolvable in PR or GO"); return(NULL) }

#ans = list(type=ont$name[curtag],
#        has=prupdate(hasdf), lacks=prupdate(lackdf),
#        high=prupdate(hasdfa), llow=prupdate(lackdfa), 
#        haspart=prupdate(haspardfa), lackspart=prupdate(lackspardfa), intdata=intdata)
#lkta = sapply(list(ans$has, ans$lacks, ans$high, ans$llow,
#          ans$haspart, ans$lackspart), function(x) x$tag[1])
#if (all(lkta=="")) {
#   message("no properties resolvable in PR or GO")
#   return(NULL)
#   }

ans = do.call(rbind, ans)

#ans = do.call(rbind, list(ans$has, ans$lacks, ans$high, ans$llow,
#          ans$haspart, ans$lackspart))
bad = which(ans$tag=="")
if (length(bad)>0) ans = ans[-bad,,drop=FALSE]
#cbind(ans, name=ont$name[curtag])
data.frame(ans, name=as.character(ont$name[curtag]))
}

#' produce a data.frame of features relevant to a Cell Ontology class
#' @param ont instance of ontologyIndex ontology
#' @param pr instance of ontologyIndex PRO protein ontology
#' @param go instance of ontologyIndex GO gene ontology
#' @param tag character(1) a CL: class tag
#' @note This function will look in the intersection_of and has_part,
#' lacks_part components of the CL entry to find properties asserted
#' of or inherited by the cell type identified in 'tag'.  As of 1.19,
#' this function does not look in global environment for ontologies.
#' We use 2021 versions in the examples because some changes in
#' ontologies omit important relationships; revisions to package
#' code after 1.19.4 will attempt to address these.
#' @return a data.frame instance
#' @examples
#' cl = getOnto("cellOnto", year_added="2021")
#' pr = getOnto("Pronto", "2021")  # legacy tag, for 2022 would be PROnto
#' go = getOnto("goOnto", "2021")
#' CLfeats(cl, tag="CL:0001054", pr=pr, go=go)
#' @export
CLfeats = function(ont, tag="CL:0001054", pr, go) {
 stopifnot(length(tag)==1, is.character(tag))
 ints = unique(c(tag, intchain(ont, tag)))
 isas = unique(c(tag, isachain(ont, tag)))
 chn = unique(c(ints,isas))
 do.call(rbind, lapply(chn, function(x) CLfeat(ont, x, pr=pr, go=go)))
}
