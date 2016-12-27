getNgramPredictionSet <- function ( s, n, dfGrams ) {
  print(s)
  sStopped <- doRemoveWords(s, tm::stopwords("en"))
  #print(sStopped)
  sStemmed <- doWordStemmer(sStopped)
  #sStemmed <- wordStemmer(s)
  #print(sStemmed)
  sStemmedLen <- length(sStemmed)
  #print(sStemmedLen)
  sStemmedSubset <- sStemmed[(sStemmedLen - (n-1) + 1):(sStemmedLen)]
  #print(sStemmedSubset)
  sQuerySubSet <- paste(sStemmedSubset, collapse = ' ')
  reQuerySubSet <- paste0("^",sQuerySubSet,"$")
  print(reQuerySubSet)
  dfGrams[grep(reQuerySubSet, dfGrams$firstterms, perl=TRUE),]
}