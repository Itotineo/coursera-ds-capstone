projectDir = "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/"
dataDir   <- paste0( projectDir, "data/")
funcDir   <- paste0( projectDir, "functions/")
wkDir <- paste0( projectDir, "week3/")
setwd(wkDir)
#set.seed("4789")

source( paste0(projectDir, "setup.R"))
source( paste0(funcDir, "globalUsePackage.R"))

usePackage("tm")
usePackage("SnowballC")
usePackage("quanteda")
usePackage("dplyr")
usePackage("tidyr")
#usePackage("RWeka")

# UPDATE CORPUS COMBINED DATASET
#portionPercentage <- 0.20
source(paste0(funcDir, "refreshCorpusCombinedDatasetFile.R"))
refreshCorpusCombinedDatasetFile( 0.05 )

# LOAD COMBINED DATASET DOCUMENT
filenameCombinedDataSubset <- paste0( dataDir, "en_US.combined_subset.txt" )

# LOAD AS TEXT DOCUMENT
doc <- readLines( filenameCombinedDataSubset, encoding = "UTF-8", skipNul = TRUE )

# LOAD PROFANITY WORDS
bannedWordList <- readLines( paste0( dataDir, "swearWords.txt" ) )  

# USING QUANTEDA PACKAGE -> DFM FEATURE
getDFM <- function( d, n ) { 
  #dfm(d, ngrams = n, stem = TRUE, verbose = FALSE, ignoredFeatures = (bannedWordList, stopwords("english")))
  dfm(d, ngrams = n, stem = FALSE, verbose = TRUE, ignoredFeatures = (bannedWordList))
  #dfm(d, ngrams = n, stem = FALSE, verbose = TRUE)
}

dfmSparse1 <- getDFM(doc, 1 )
dfmSparse2 <- getDFM(doc, 2 )
dfmSparse3 <- getDFM(doc, 3 )
dfmSparse4 <- getDFM(doc, 4 )

# REMOVE SPARSE FEATURES USING TRIM QUANTEDA TRIM FUNCTION
#https://rdrr.io/cran/quanteda/man/trim.html
dfmSparse1tr <- trim(dfmSparse1, minCount = 2, minDoc = 2)
dfmSparse2tr <- trim(dfmSparse2, minCount = 2, minDoc = 2)
dfmSparse3tr <- trim(dfmSparse3, minCount = 2, minDoc = 2)
dfmSparse4tr <- trim(dfmSparse4, minCount = 2, minDoc = 2)

# GET TOP FEATURES
source(paste0(funcDir, "getTopFeaturesGrams.R"))
nHowManyFeatures <- 1000000
dfGrams1 <- getTopFeaturesGrams(dfmSparse1tr, ncol(dfmSparse1tr))
dfGrams2 <- getTopFeaturesGrams(dfmSparse2tr, ncol(dfmSparse2tr))
dfGrams3 <- getTopFeaturesGrams(dfmSparse3tr, ncol(dfmSparse3tr))
dfGrams4 <- getTopFeaturesGrams(dfmSparse4tr, ncol(dfmSparse4tr))

countUnigrams <- sum(dfGrams1$tf)
dfGrams1$score <- dfGrams1$tf / countUnigrams

# SANITY CHECK:
#dim(dfGrams1)
#dim(dfGrams2)
#dim(dfGrams3)
#dim(dfGrams4)

# PERFORM PREDICTIONS
source(paste0(funcDir, "doRemoveWords.R"))
source(paste0(funcDir, "doWordStemmer.R"))
source(paste0(funcDir, "getNgramPredictionSet.R"))
source(paste0(funcDir, "doPredict.R"))
source(paste0(projectDir, "tester_quiz_common.R"))
source(paste0(projectDir, "tester_quiz_2.R"))
source(paste0(projectDir, "tester_quiz_3.R"))

quizzer <- function( quiz, question ) {
  cat("-----------------------------------------------------------------\n")
  cat("PREDICTION:\n")
  resultPrediction <- doPredict(quiz[[question]]@question)
  print(resultPrediction)
  cat("----------\n")
  cat("ANSWERS:\n")
  print(quiz[[question]]@answer)
}

quizzer( q3, 7)

