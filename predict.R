projectDir = "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/"
dataDir   <- paste0( projectDir, "data/")
funcDir   <- paste0( projectDir, "functions/")
wkDir <- paste0( projectDir, "")
setwd(wkDir)
#set.seed("4789")

# LOAD PACKAGES 
source( paste0(funcDir, "globalUsePackage.R"))
usePackage("qdap")
usePackage("data.table")

# PREDICTION FUNCTIONALTIY
source(paste0(funcDir, "doRemoveWords.R"))

# LOAD NGRAM DATAFRAMES
dfGrams1 <- fread(paste0( dataDir, "en_US.combined_grams_1.csv" ))
dfGrams2 <- fread(paste0( dataDir, "en_US.combined_grams_2.csv" ))
dfGrams3 <- fread(paste0( dataDir, "en_US.combined_grams_3.csv" ))
dfGrams4 <- fread(paste0( dataDir, "en_US.combined_grams_4.csv" ))
dfGrams5 <- fread(paste0( dataDir, "en_US.combined_grams_5.csv" ))

# PREPARE UNI-GRAMS -> GLOBAL SET THAT IS REUSED BETWEEN PREDICTIONS
subGrams1 <- dfGrams1
subGrams1TotalTokensN <- sum(subGrams1$tf)
setnames(subGrams1, 'firstterms','token')
subGrams1[, `:=`(ngram=1, discount=0, score=0)]
subGrams1$score <- round(subGrams1$tf / subGrams1TotalTokensN,5)

# DEBUG SCORING
debugScoring <- function( x, ngram.level, term, base, term.freq, ngram.count, ngram.count.term, discount, score) {
  x <- append(x, paste0(
         "lvl=", ngram.level, " | ", "token=", term, " | ",  "base=", base, " | ", 
         "tf=", term.freq, " | ", "ngram-1.count=", ngram.count, " | ", 
         "ngram-1.count(",term,")=", ngram.count.term, " | ", 
         "discount=", discount, " | ", "score=", score))
  x
}

# CREATE CLASS WRAPPING A PREDICTION RESULT
# S3 setClass("Prediction", slots = list(input = "character", output = "data.frame", debug = "character", error = "character"))
setClass("Prediction", representation(input = "character", output = "data.frame", debug = "character", error="character"))

# ------------------------------------------------------
# FUNC -> DO-PREDICT
doStupidBackOffPredict <- function ( sentence ) {
  debug <- c("")
  sentence <- tolower(Trim(clean(sentence)))
  
  # VALIDATE INPUT 
  if ( nchar(sentence) == 0 ) {
    emptyOutput <- data.frame(empty=character(),stringsAsFactors=FALSE)
    errMsg <- "The sentence is empty"
    return (new ("Prediction", input = sentence, output = emptyOutput , debug = debug, error=errMsg))
  }

  # INNER FUNCTION -> GET NGRAM PREDICTION SET
  getNgramPredictionSet <- function ( sentence, ngram.level, dfGrams ) {
    s <- unlist(strsplit(sentence, " "))
    sLen <- length(s)
    if (sLen >= (ngram.level-1)) {
    
      sSubset <- s[(sLen - (ngram.level-1) + 1):(sLen)]
      sQuerySubSet <- paste(sSubset, collapse = ' ')
      reQuerySubSet <- paste0("^",sQuerySubSet,"$")
      ngSubset <- dfGrams[grep(reQuerySubSet, dfGrams$firstterms, perl=TRUE),]
      output <- ngSubset
      if ( nrow(output) > 0 ) {
        output[, `:=`(ngram=ngram.level, discount=0, score=0)]
      }
      output <- output[with(output, order(-tf)), ]
      output
    }
    else {
      data.table(V1=character())
    }
  }

  # GET PREDICTION SETS
  subGrams5 <- getNgramPredictionSet( sentence, 5, dfGrams4 )
  subGrams4 <- getNgramPredictionSet( sentence, 4, dfGrams4 )
  subGrams3 <- getNgramPredictionSet( sentence, 3, dfGrams3 )
  subGrams2 <- getNgramPredictionSet( sentence, 2, dfGrams2 )
  
  # INNER FUNC -> INNER FUNCTION: SCORE MULTIGRAMS ( ngram >= 3 )  (STUPID BACKOFF APPROACH)
  scoreMultiGrams <- function ( ngram.level, gA, gB, discount, debug ) {
    countB <- sum( gB$tf )
    baseB <- unique( gB$firstterms )
    for (term in gA$lastterm) {
      countBB <- gB[gB$lastterm == term,]$tf
      score <- round((gA[gA$lastterm == term,]$tf / countB) * discount, 5)
      gA[gA$lastterm == term,]$score = score
      #debug <- debugScoring(debug, ngram.level, term, (gA[gA$lastterm == term,]$firstterms), (gA[gA$lastterm == term,]$tf), countB, countBB, discount, score)
    }
    if("score" %in% colnames(gA)) gA <- gA[with(gA, order(-score)), ]
    gA
  }
 
  # INNER FUNC -> SCORE BIGRAMS (STUPID BACKOFF APPROACH)
  scoreBiGrams <- function ( ngram.level, gA, gB, discount, debug ) {
    for (term in gA$lastterm) {
      countB <- gB[gB$token == term,]$tf
      score <- round((gA[gA$lastterm == term,]$tf / countB) * discount, 5)  
      gA[gA$lastterm == term,]$score = score
      #debug <- debugScoring(debug, ngram.level, term, (gA[gA$lastterm == term,]$firstterms), (gA[gA$lastterm == term,]$tf), countB, countB, discount, score) 
    }
    if("score" %in% colnames(gA)) gA <- gA[with(gA, order(-score)), ]
    gA
  }

  # STUPID BACKOFF SCORING
  scoredGrams5 <- scoreMultiGrams( 5, subGrams4, subGrams4, 1, debug)
  scoredGrams4 <- scoreMultiGrams( 4, head(subGrams4, 100), subGrams3, 0.4^1, debug)
  scoredGrams3 <- scoreMultiGrams( 3, head(subGrams3, 100), subGrams2,  0.4^2,debug )
  scoredGrams2 <- scoreBiGrams( 2, head(subGrams2, 100), subGrams1, 0.4^3, debug )
  
  # FUNC -> COMBINE TOKENS
  combineTokens <- function ( ngram.level, combinedScoreTokens, scoredGrams) {
    if ( nrow(scoredGrams) > 0) {
      subScoredGrams <- subset(scoredGrams, select=c("lastterm", "score", "ngram"))
      setnames(subScoredGrams, 'lastterm','token')
      copySet <- setdiff(subScoredGrams$token, combinedScoreTokens$token)
      if ( length(copySet) > 0 ) {
        copySetSubScoredGrams <- subScoredGrams[subScoredGrams$token %in% copySet,]
        rbind(combinedScoreTokens, copySetSubScoredGrams )
      }
      else { combinedScoreTokens }
    }
    else { combinedScoreTokens }
  }
  
  # COMBINE SCORED TOKENS IN SINGLE DATA.FRAME
  combinedScoreTokens <- data.table(token=character(), score=numeric(), ngram=character()) 
  combinedScoreTokens <- combineTokens(5, combinedScoreTokens, scoredGrams5)
  combinedScoreTokens <- combineTokens(4, combinedScoreTokens, scoredGrams4)
  combinedScoreTokens <- combineTokens(3, combinedScoreTokens, scoredGrams3)
  combinedScoreTokens <- combineTokens(2, combinedScoreTokens, scoredGrams2)
  
  # ORDER BY SCORE DESC -> HIGHEST TO LOWEST
  output <- head( combinedScoreTokens[with(combinedScoreTokens, order(-score)), ], 5)
  
  # SUBSET NUMBER OF PREDICTIONS TO RETURN
  if (nrow(output) == 0) {
    output <- head(subGrams1, 5)
  }
  
  # RETURN PREDICTION OBJECT
  oPrediction <- new ("Prediction", input = sentence, output = output, debug = debug, error = "")
  oPrediction
}
