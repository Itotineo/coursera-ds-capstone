# FUNCTION: GET-CORPUS-PREPROCESSED
getCorpusPreprocessed <- function( dCorpus ) {
  
  # TRANSFORM TO LOWERCASE
  dCorpus <- tm_map( dCorpus, tolower )
  
  # STRIP UNNECESSARY ITEMS
  dCorpus <- tm_map( dCorpus, stripWhitespace )
  dCorpus <- tm_map( dCorpus, removeNumbers )
  dCorpus <- tm_map( dCorpus, removePunctuation )
  
  # REMOVE BANNED, HIGHLY COMPLEX, NON-ENGLISH AND STOPWORDS
  dCorpus <- tm_map( dCorpus, function(x) iconv(x, "UTF-8", "ASCII", sub="") )
  dCorpus <- tm_map( dCorpus, removeWords, bannedWordList )  # PROFRANITY FILTER
  dCorpus <- tm_map( dCorpus, removeWords, stopwords("english") ) 
  
  # STEMMING ( WORD ROOT )
  dCorpus <- tm_map( dCorpus, stemDocument )
  
  # ENSURE PLAIN TEXT DOCUMENT
  dCorpus <- tm_map( dCorpus, PlainTextDocument )  
  
  customRemoveStopWords <- function(x) removeWords( x, stopwords("english") )
  customRemoveBannedWords <- function(x) removeWords( x, bannedWordList )
  customRemoveUnknownContent <- function(x) iconv(x, "UTF-8", "ASCII", sub="")
  
  #funcs <- list(
  #  tolower, removePunctuation, removeNumbers, stripWhitespace, 
  #  customRemoveBannedWords, customRemoveUnknownContent,
  #  customRemoveStopWords) 
  
  #dCorpus <- tm_map( dCorpus, FUN = tm_reduce, tmFuns = funcs)
  #dCorpus <- tm_map( dCorpus, stemDocument )
  #dCorpus <- tm_map( dCorpus, PlainTextDocument)  
  
  dCorpus # RETURN FILTERED CORPUS!
}
