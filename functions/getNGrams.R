# FUNC -> GET DATA.FRAME OF NGRAMS
getNGrams <- function( doc, n) {
  # LOAD PROFANITY WORDS
  bannedWordList <- readLines( paste0( dataDir, "swearWords.txt" ) )  
  
  # USING QUANTEDA PACKAGE -> DFM FEATURE  
  dfmSparse <- dfm(doc, ngrams = n, stem = FALSE, verbose = TRUE, ignoredFeatures = (bannedWordList))
  
  # REMOVE SPARSE FEATURES -> TRIM FUNCTION https://rdrr.io/cran/quanteda/man/trim.html
  dfmSparsetr <- trim(dfmSparse, minCount = 2, minDoc = 2)
  
  # GET TOP GRAMS
  source(paste0(funcDir, "getTopFeaturesGrams.R"))
  getTopFeaturesGrams(dfmSparsetr, ncol(dfmSparsetr))
}