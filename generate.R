projectDir = "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/"

dataDir   <- paste0( projectDir, "data/")
funcDir   <- paste0( projectDir, "functions/")
wkDir <- paste0( projectDir, "")
setwd(wkDir)
#set.seed("4789")

# LOAD PACKAGES 
source( paste0(funcDir, "globalUsePackage.R"))
usePackage("tm")
usePackage("SnowballC")
usePackage("quanteda")
usePackage("dplyr")
usePackage("tidyr")
usePackage("data.table")
usePackage("feather")
usePackage("readr")
#usePackage("RWeka")

# LOAD COMBINED DATASET DOCUMENT
filenameCorpus <- paste0( dataDir, "en_US.combined_subset.txt" )

# UPDATE CORPUS COMBINED DATASET
source(paste0(funcDir, "refreshCorpus.R"))
refreshCorpus( 0.02, filenameCorpus  )

# LOAD AS TEXT DOCUMENT
doc <- readLines( filenameCombinedDataSubset, encoding = "UTF-8", skipNul = TRUE )

# GENERATE LISTS OF NGRAMS
source(paste0(funcDir, "getNGrams.R"))
dfGrams1 <- getNGrams( doc, 1)
dfGrams2 <- getNGrams( doc, 2)
dfGrams3 <- getNGrams( doc, 3)
dfGrams4 <- getNGrams( doc, 4)
dfGrams5 <- getNGrams( doc, 5)

# SAVE GRAMS & METADATA
write.csv(dfGrams1, paste0( dataDir, "en_US.combined_grams_1.csv" ))
write.csv(dfGrams2, paste0( dataDir, "en_US.combined_grams_2.csv" ))
write.csv(dfGrams3, paste0( dataDir, "en_US.combined_grams_3.csv" ))
write.csv(dfGrams4, paste0( dataDir, "en_US.combined_grams_4.csv" ))
write.csv(dfGrams5, paste0( dataDir, "en_US.combined_grams_5.csv" ))

# CLEAN UP ENVIRONMENT
rm("doc")
rm(list = c("dfGrams1","dfGrams2","dfGrams3","dfGrams4","dfGrams5"))
rm(list = c("getTopFeaturesGrams","getNGrams","refreshCorpus","corpusCleanup"))
rm(list = c("projectDir","dataDir","funcDir","wkDir"))
rm("usePackage")
rm("filenameCorpus")