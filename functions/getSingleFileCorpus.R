getSingleFileCorpus <- function( filename ) {
  VCorpus( VectorSource( paste(readLines(file( filename )) ,collapse="\n") ), list(reader = readPlain) )
} 