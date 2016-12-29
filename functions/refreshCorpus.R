# ---------------------------------------------------------------------
# REFRESH CORPUS
# Extract a percentage from a series of documents and perform a cleanse.
# Combine all documents into a single file
# author: smallwesley
# ---------------------------------------------------------------------
refreshCorpus <- function( portionPercentage, outputFilePath ) {

  enUSBaseFilePath    <- paste0( dataDir, "final/en_US/" )
  enUSBlogsFilename   <- "en_US.blogs.txt"
  enUSBlogsFilepath   <- paste0( enUSBaseFilePath, enUSBlogsFilename ) 
  enUSNewsFilename    <- "en_US.news.txt"
  enUSNewsFilepath    <- paste0( enUSBaseFilePath, enUSNewsFilename )
  enUSTwitterFilename <- "en_US.twitter.txt"
  enUSTwitterFilepath <- paste0( enUSBaseFilePath, enUSTwitterFilename )
  
  # LOAD DATASET IN QUESTION
  tic("RC: ReadLines")
  dBlogs    <- readLines( enUSBlogsFilepath, encoding = "UTF-8", skipNul = TRUE )
  dNews     <- readLines( enUSNewsFilepath, encoding = "UTF-8", skipNul = TRUE )
  dTwitter  <- readLines( enUSTwitterFilepath, encoding = "UTF-8", skipNul = TRUE )
  toc()
  
  # SUBSET BY TAKING A SAMPLE PERCENTAGE OF EACH FILE
  tic("RC: Subset Combined")
  subsetPercentage <- portionPercentage 
  getDataSubset <- function( df, sp = subsetPercentage ) { sample(df, length(df) * sp )  }
  dCombinedDataSubset <- c( getDataSubset( dBlogs ), getDataSubset( dNews ), getDataSubset( dTwitter ) )
  #moprint(length(dCombinedDataSubset))
  toc()
  
  # CLEANSE
  tic('RC: Scrubbing Combined')
  source( paste0(funcDir, "cleanseText.R"))
  dCombinedDataSubset <- cleanseText (dCombinedDataSubset, TRUE, TRUE)
  #print(length(dCombinedDataSubset))
  toc()
  
  # STORE COMBINED TRAINING DATASET
  tic('RC: Store Data Subset')
  filenameCombinedDataSubset <- outputFilePath
  if (file.exists(filenameCombinedDataSubset)) { 
    file.remove(filenameCombinedDataSubset)
  }
  fileCombinedDataSubset <- file(filenameCombinedDataSubset)
  writeLines(dCombinedDataSubset, fileCombinedDataSubset)
  close(fileCombinedDataSubset)
  toc()
}