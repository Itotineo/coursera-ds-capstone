corpusCleanup <- function ( x ) {
  
  # MINOR CONVERSION TO ASCII
  x <- iconv(x, "latin1", "ASCII", sub=" ");
  
  x <- tolower(x)
  
  # REMOVE TWITTER HASHTAGS
  x <- gsub("#\\S*","", x) 
  
  # REMOVE URLS
  x <- gsub("(f|ht)(tp)(s?)(://)(\\S*)", "", x)

  # REMOVE STRINGS WITH FORWARD SLASH STRINGS
  x <- gsub("\\b\\S*//\\S*\\b", "", x)

  # REMOVE EMAILS STYLE SIGNATURES
  x <- gsub("\\b\\S*@\\S*(/.?)\\S*\\b", "", x)  
    
  # REMOVE WORDS WITH UNDERSCORE & DASH
  x <- gsub("\\b\\S*_\\S*\\b", "", x)
  x <- gsub("\\b\\S*-\\S*\\b", "", x)
  
  # DEAL WITH OTHER "PERIOD SIGNATURES"
  x <- gsub("\\bmr.\\b", " mr", x)
  x <- gsub("\\bmrs.\\b", " mrs", x)
    
  # SPLIT LINES BY PUNCTUATION MARKS
  x <- unlist( strsplit(x, "[.;!?] *"))  
  x <- unique(x)
  
  # REMOVE ALL SYMBOLS -> LEAVE 
  #x <- gsub("[^A-Za-z///' ]", "", x) 
  #x <- gsub("[^[:alpha:][:space:]'\\.]", "", x)
  gsub("[^[:alpha:][:space:]'-]","" ,x)

  # MODIFY 'APOSTROPHE ENDINGS
  x <- gsub("'s", "", x)
  
  #WORD SUBSTITUTIONS
  x <- gsub("\\bwk\\b", "week", x)
  x <- gsub("wknd|wkend", "weekend", x)
  x <- gsub("\\bst\\b", "state", x)
  x <- gsub("fax to|email to", "", x)
  x <- gsub("^com$", "", x)
  x <- gsub("^com ", "", x)
  #x <- gsub("", "", x)
  #shortword = re.compile(r'\W*\b\w{1,3}\b')
  
  x
}