# ---------------------------------------------------------------------
# CLEANSE TEXT
# Tidy & filter a body of text (sentence, document, vector of characaters)
# author: smallwesley
# ---------------------------------------------------------------------
cleanseText <- function ( x, deepclean = FALSE, log = FALSE ) {
  logger <- function ( x ) { if (log) cat(paste0(x,"\n"))}

  if (log) logger("<START> cleanseText")
  if (log) tic('cleanseText')
  
  # CONVERT TO ASCII
  if (deepclean) {
    if (log) logger("> ASCII")
    if (log) tic(' ... ASCII')
    x <- iconv(x, "latin1", "ASCII", sub=" ");
    if (log) toc()
  }
  
  # LOWER CASE EVERYTHING
  if (log) logger("> lowercasing")
  if (log) tic(' ... Lowercasing')
  x <- tolower(x)
  if (log) toc()
  
  # REMOVE TWITTER HASHTAGS
  if (log) logger("> remove twitter tags")
  if (log) tic(' ... minus ###s')
  x <- gsub("#\\S*","", x,perl = TRUE) 
  if (log) toc()
  
  # REMOVE URLS
  if (log) logger("> remove urls")
  if (log) tic(' ... minus urls')
  x <- gsub("(f|ht)(tp)(s?)(://)(\\S*)", "", x,perl = TRUE)
  if (log) toc()
  
  # REMOVE STRINGS WITH FORWARD SLASH STRINGS
  if (log) tic(' ... minus slash')
  if (log) logger("> remove forwardslashs ")
  x <- gsub("\\b\\S*//\\S*\\b", "", x,perl = TRUE)
  if (log) toc()
  
  # REMOVE EMAILS STYLE SIGNATURES
  if (log) logger("> remove email signatures")
  if (log) tic(' ... minus email@')
  x <- gsub("\\b\\S*@\\S*(/.?)\\S*\\b", "", x,perl = TRUE)  
  if (log) toc()
  
  # REMOVE WORDS WITH UNDERSCORE & DASH
  if (log) logger("> remove undercores & dashes")
  if (log) tic(' ...   ^...  ')
  x <- gsub("\\b\\S*_\\S*\\b", "", x,perl = TRUE)
  x <- gsub("\\b\\S*-\\S*\\b", "", x,perl = TRUE)
  if (log) toc()
  
  # DEAL WITH OTHER "PERIOD SIGNATURES"
  if (log) logger("> modify salutations")
  if (log) tic(' ... minus modify')
  x <- gsub("\\bmr.\\b", " mr", x,perl = TRUE)
  x <- gsub("\\bmrs.\\b", " mrs", x,perl = TRUE)
  x <- gsub("\\bdr.\\b", " mrs", x,perl = TRUE)
  if (log) toc()
  
  # REMOVE WORDS WITH NUMBERS IN THEM
  if (log) logger("> remove alphanumeric combo words")
  if (log) tic(' ... minus numeros')
  x <- gsub(" ?\\b[^ ]*[0-9][^ ]*\\b", "", x,perl = TRUE)
  if (log) toc()
  
  # SPLIT LINES BY PUNCTUATION MARKS
  if (deepclean) {
    if (log) logger("> splitting by sentence punctuation")
    if (log) tic(' ... split [:punct]')
    x <- unlist( strsplit(x, "[.;!?] *"))  
    x <- unique(x)
    if (log) toc()
  }
  
  # REMOVE ALL OTHER SYMBOLS NUMBERS
  if (log) logger("> remove all non-alpha")
  if (log) tic(' ... minus symbols')
  x <- gsub("[^[:alpha:][:space:]'minus]", "" , x,perl = TRUE)
  if (log) toc()
  
  # MODIFY 'S ENDINGS
  if (log) logger("> remove 's endings")
  if (log) tic(' ... minus esses')
  x <- gsub("'s", "", x,perl = TRUE)
  if (log) toc()
  
  # EXECUTE SOME TRICKY WORD SUBSTITUTIONS
  if (log) logger("> word substitutions")
  if (deepclean) {
    if (log) tic(' ... word subs')
    x <- gsub("\\bwk\\b", "week", x,perl = TRUE)
    x <- gsub("wknd|wkend", "weekend", x,perl = TRUE)
    x <- gsub("\\bst\\b", "state", x,perl = TRUE)
    x <- gsub("fax to|email to", "", x,perl = TRUE)
    x <- gsub("^com$", "", x,perl = TRUE)
    x <- gsub("^com ", "", x,perl = TRUE)
    if (log) toc()
  }
  
  if (deepclean) {
    # TRY TO REMOVE 2-LETTER WHOLE WORDS EXCEPT MOST USED
    if (log) logger("> remove abnormal two letter words")
    if (log) tic(' ... minus 2L words')
    L2 <- unlist(strsplit("am,an,at,be,by,do,if,is,it,go,he,me,my,no,of,on,or,so,to,up,us,to,we",","))
    mx2 <- regexpr(" \\b\\w{2}\\b ", x, perl=TRUE)
    rm2 <- unique(trimws(regmatches(x, mx2)))
    rm2b <- paste0(rm2[!(rm2 %in% L2)],collapse = "|")
    patt <- paste0(" \\b(",rm2b,")\\b |^\\b(",rm2b,")\\b | \\b(",rm2b,")\\b$")
    x <- gsub(patt," ", x,perl = TRUE, fixed = FALSE);
    if (log) toc()
    
    # TRY TO REMOVE SINGLE-LETTER WHOLE WORDS EXCEPT A & I
    if (log) tic(' ... minus 1L words')
    if (log) logger("> remove abnormal single letter words")
    L1 <- paste0(letters[c(-1,-9)],collapse = "|")
    x <- gsub(paste0(" \\b(",L1,")\\b |^\\b(",L1,")\\b | \\b(",L1,")\\b$")," ", x,perl = TRUE, fixed = FALSE)
    if (log) toc()
  }
  
  # ONE LAST CLEAN UP (QDAP)
  if (log) logger("> execute qdap clean & trim")
  if (log) tic(' ... qdap - clean trim')
  x <- Trim(clean(x))
  if (log) toc()
  
  # KEEP LINES WITH AT LEAST 2 OR MORE WORDS (QDAP PACKAGE)
  if (deepclean) {
    if (log) tic(' ... word count > 1 ')
    if (log) logger("> keep lines with at least 2 or more words ")
    x <- x[wc(x) > 1]
    if (log) toc()
  }
    
  # ------------------------
  # RETURN TIDY DOCUMENT "X"
  if (log) logger("<END> cleanseText")
  if (log) toc()
  x
}