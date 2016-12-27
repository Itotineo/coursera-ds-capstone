getBannedWordList <- function() {
  readLines( paste0( dataDir, "swearWords.txt" ) )
}