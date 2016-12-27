getNgramPredictionSet <- function ( sentence, ngram.level, dfGrams, subsetCount ) {
  s <- tolower( sentence )
  s <- unlist(strsplit(s, " "))
  sLen <- length(s)
  sSubset <- sStemmed[(sLen - (ngram.level-1) + 1):(sLen)]
  sQuerySubSet <- paste(sStemmedSubset, collapse = ' ')
  sQuerySubSet <- sapply(sQuerySubSet, tolower)
  reQuerySubSet <- paste0("^",sQuerySubSet,"$")
  ngSubset <- dfGrams[grep(reQuerySubSet, dfGrams$firstterms, perl=TRUE),]
  #output <- head(ngSubset, subsetCount)
  output <- ngSubset
  if (nrow(output) > 0) {
    output["score"] <- rep(0.0,nrow(output))
    output["discount"] <- rep(1,nrow(output))
    output["type"] <- rep(paste0("ngram.",ngram.level),nrow(output))
  }
  output
}
