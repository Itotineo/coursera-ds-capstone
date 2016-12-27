refreshCorpus <- function( portionPercentage, outputFilePath ) {

  enUSBaseFilePath    <- paste0( dataDir, "final/en_US/" )
  enUSBlogsFilename   <- "en_US.blogs.txt"
  enUSBlogsFilepath   <- paste0( enUSBaseFilePath, enUSBlogsFilename ) 
  enUSNewsFilename    <- "en_US.news.txt"
  enUSNewsFilepath    <- paste0( enUSBaseFilePath, enUSNewsFilename )
  enUSTwitterFilename <- "en_US.twitter.txt"
  enUSTwitterFilepath <- paste0( enUSBaseFilePath, enUSTwitterFilename )
  
  # LOAD DATASET IN QUESTION
  dBlogs    <- readLines( enUSBlogsFilepath, encoding = "UTF-8", skipNul = TRUE )
  dNews     <- readLines( enUSNewsFilepath, encoding = "UTF-8", skipNul = TRUE )
  dTwitter  <- readLines( enUSTwitterFilepath, encoding = "UTF-8", skipNul = TRUE )

  # SUBSET BY TAKING A SAMPLE PERCENTAGE OF EACH FILE
  subsetPercentage <- portionPercentage 
  getDataSubset <- function( df, sp = subsetPercentage ) { sample(df, length(df) * sp )  }
  dCombinedDataSubset <- c( getDataSubset( dBlogs ), getDataSubset( dNews ), getDataSubset( dTwitter ) )
  #moprint(length(dCombinedDataSubset))
  
  # PRELIMINARY CLEAN UP
  source( paste0(funcDir, "corpusCleanupScript.R"))
  dCombinedDataSubset <- corpusCleanup (dCombinedDataSubset)
  #print(length(dCombinedDataSubset))
  
  # STORE COMBINED TRAINING DATASET
  filenameCombinedDataSubset <- outputFilePath
  if (file.exists(filenameCombinedDataSubset)) { 
    file.remove(filenameCombinedDataSubset)
  }
  fileCombinedDataSubset <- file(filenameCombinedDataSubset)
  writeLines(dCombinedDataSubset, fileCombinedDataSubset)
  close(fileCombinedDataSubset)
}