# ---------------------------------------------------------------------
# GENERATE NGRAM LOOKUP FILES
# Perform a set of operations to generate a set of NGRAM Lookup Files.
# author: smallwesley
# ---------------------------------------------------------------------
projectDir = "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/"

dataDir   <- paste0( projectDir, "data/")
funcDir   <- paste0( projectDir, "functions/")
wkDir <- paste0( projectDir, "")
setwd(wkDir)
#set.seed("4789")

# LOAD PACKAGES 
SCRUB_ENVIRONMENT <- FALSE
source( paste0(funcDir, "globalUsePackage.R"))
usePackage("tm")
usePackage("SnowballC")
usePackage("quanteda")
usePackage("dplyr")
usePackage("tidyr")
usePackage("data.table")
usePackage("feather")
usePackage("readr")
usePackage("qdap")
#usePackage("RWeka")
usePackage("tictoc")

# LOAD COMBINED DATASET DOCUMENT
filenameCorpus <- paste0( dataDir, "en_US.combined_subset.txt" )

# UPDATE CORPUS COMBINED DATASET
tic('GENERATE: Refresh Corpus')
source(paste0(funcDir, "refreshCorpus.R"))
refreshCorpus( 0.05, filenameCorpus  ) # 0.05 => 5% of each document
toc()

# LOAD AS TEXT DOCUMENT
tic('GENERATE: Load Combined Corpus DOC')
doc <- readLines( filenameCorpus, encoding = "UTF-8", skipNul = TRUE )
toc()

# GENERATE LISTS OF NGRAMS
tic('GENERATE: Build NGRAMS')
source(paste0(funcDir, "getNGrams.R"))
dfGrams1 <- getNGrams( doc, 1)
dfGrams2 <- getNGrams( doc, 2)
dfGrams3 <- getNGrams( doc, 3)
dfGrams4 <- getNGrams( doc, 4)
dfGrams5 <- getNGrams( doc, 5)
toc()

# RESET ROW NAMES
tic('GENERATE: R Row Names')
rownames(dfGrams1) <- NULL
rownames(dfGrams2) <- NULL
rownames(dfGrams3) <- NULL
rownames(dfGrams4) <- NULL
rownames(dfGrams5) <- NULL
toc()

# SAVE GRAMS & METADATA
tic('Save NGram Files')
write.csv(dfGrams1, paste0( dataDir, "en_US.combined_grams_1.csv" ))
write.csv(dfGrams2, paste0( dataDir, "en_US.combined_grams_2.csv" ))
write.csv(dfGrams3, paste0( dataDir, "en_US.combined_grams_3.csv" ))
write.csv(dfGrams4, paste0( dataDir, "en_US.combined_grams_4.csv" ))
write.csv(dfGrams5, paste0( dataDir, "en_US.combined_grams_5.csv" ))
toc()

# CLEAN UP ENVIRONMENT
if (SCRUB_ENVIRONMENT == TRUE ) {
  rm("doc")
  rm(list = c("dfGrams1","dfGrams2","dfGrams3","dfGrams4","dfGrams5"))
  rm(list = c("getTopFeaturesGrams","getNGrams","refreshCorpus","cleanseText"))
  rm(list = c("projectDir","dataDir","funcDir","wkDir"))
  rm("usePackage")
  rm("filenameCorpus")
}