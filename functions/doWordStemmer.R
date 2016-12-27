doWordStemmer <- function(x) {
  mywords <- unlist(strsplit(x, " "))
  mycleanwords <- gsub("^\\W+|\\W+$", "", mywords, perl=T)
  mycleanwords <- mycleanwords[mycleanwords != ""]
  wordStem(mycleanwords)
}