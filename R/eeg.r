library("rhdf5")

# Reads a HDF5 file into a NoisyParameters object.
#   np <- NoisyParameter("file.h5")
#   np@resampling$originalFrequency

# HDReader
setClass("HDReader",
  representation(
    file="character",
    contents="data.frame"
))

# constructor
.HDReader <- function(file) {
  contents <- h5ls(file)
  np <- new("HDReader", file=file, contents=contents)
  .gen(np)
  return(np)
}

# generic access function
setGeneric(".access",
  function(object, ...) {
    standardGeneric(".access")
})

setMethod(".access", signature(object="HDReader"),
  function(object, part) {
    h5read(object@file, part)
})

# generates the functions to read in specific fields from the HDF5 file, i.e
# reference.channelInformation(new HDReader("file")) to read the
# channelInformation field.
.gen <- function(np) {
  for (i in 1:length(np@contents$name)) {
    row <- np@contents[i, ]
    
    section <- paste(row$group, row$name, sep="/")
    fName <- gsub("([a-z])/", "\\1.",
                  gsub("^/noisyParameters/", ".", section))
    # generate generic methods
    setGeneric(fName,
      eval(substitute(function(object) {
        return(.access(object, section))
      })))
      
    setMethod(fName, signature(object="HDReader"),
      eval(substitute(function(object) {
        return(.access(object, section))
      })))
  }
}

# Constructor for noisyParameters
# dynamically generates the class and the attributes
NoisyParameters <- function(file) {
  hd <- .HDReader(file)
  slots <- list()
  slots[["reader"]] <- "ANY"
  slots[["name"]] <- "ANY"
  for (i in 1:length(hd@contents$name)) {
    row <- hd@contents[i, ]
    # only grab the groups at the top-level
    if (toString(row$otype) == "H5I_GROUP" && row$group=="/noisyParameters") {
      slots[[row$name]] <- "ANY"
    }
  }
  
  setClass('noisyParameters', slots=slots)
  np <- new("noisyParameters")
  slot(np, "reader") <- hd
  slot(np, "name") <- .name(hd)
  
  names <- slotNames(np)
  names.length <- length(names)
  
  
  for (i in 2:names.length) {
    func <- paste("function() { return(", ".",names[i], "(hd)", ")}", sep="")
    slot(np, names[i]) <- 
      eval(parse(text=func))
  }
  return(np)
}