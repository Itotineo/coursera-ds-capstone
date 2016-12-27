usePackage<-function(p){
  # load a package if installed, else load after installation.
  # Args: p: package name in quotes
  if (!is.element(p, installed.packages()[,1])){
    #print(paste('Package:',p,'Not found, Installing Now...'))
    suppressMessages(install.packages(p, dep = TRUE))
  }
  #print(paste('Loading Package :',p))
  require(p, character.only = TRUE)  
}

# LOAD LIBRARIES
usePackage("tm")   
usePackage("RWeka")
usePackage("SnowballC")
usePackage("ggplot2")
usePackage("dplyr")
usePackage("stringi")
usePackage("png")
usePackage("grid")
#install.packages("rJava","http://rforge.net/",type="source")
#usePackage("NLP")
#usePackage("SnowballC")
#usePackage("stringi")
#usePackage("R.utils")
#usePackage("wordcloud")
#usePackage("RColorBrewer")
#library(parallel, quietly=T)
#library(doParallel, quietly=T)
# SET ENVIRONMENT

set.seed("4789")
setwd("/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/week2/")

# DATASET PATHS
dataBaseFilePath   <- "/Users/smallwes/develop/academic/coursera/datascience/c10-capstone/data/"
enUSBaseFilePath    <- paste0( dataBaseFilePath, "final/en_US/" )
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

# SUMMARY STATISTICS OF DATA FILES
getDatasetFileSummaryRow <- function(key, path, data) {
  i <- stri_stats_latex(data)
  r <- c(key, 
         as.character( round(file.info(path)$size / 1024^2, 1)), 
         as.character( formatC( length(data), format="d", big.mark=',') ), 
         as.character( formatC( i["Words"], format="d", big.mark=',') ),
         as.character( formatC( max(nchar(data))), format="d", big.mark=',') )
  d <- data.frame(as.list(r), stringsAsFactors=F)
  names(d) <- c("KY","SZ","LN","WL","LG")
  d
}

summaryDataset <- data.frame( KY = character(), SZ = character(), LN = character(), WL = character(),LG = character(), stringsAsFactors = FALSE)
summaryDataset <- bind_rows(summaryDataset, getDatasetFileSummaryRow( enUSBlogsFilename, enUSBlogsFilepath, dBlogs) )
summaryDataset <- bind_rows(summaryDataset, getDatasetFileSummaryRow( enUSNewsFilename, enUSNewsFilepath, dNews) )
summaryDataset <- bind_rows(summaryDataset, getDatasetFileSummaryRow( enUSTwitterFilename, enUSTwitterFilepath, dTwitter) )
names(summaryDataset) <- c("Text File", "Size (MB)", "No. of Lines", "No. of Words","Longest Line Length")
head(summaryDataset)
rm("summaryDataset")


# DEMONSTRATION OF COMPLEX CHARACTER CLEANING
dBlogs[1606]
iconv(dBlogs, "UTF-8", "ASCII", sub="")[1606]

dNews[885923]
iconv(dNews, "UTF-8", "ASCII", sub="")[885923]

dTwitter[253]
iconv(dTwitter, "UTF-8", "ASCII", sub="")[253]

## -------------------------------------------------
## BUILD CORPUSES...
## -------------------------------------------------

# CREATE CORPUS INDIVIDUAL FILES
getSingleFileCorpus <- function( filename ) {
  VCorpus( VectorSource( paste(readLines(file( filename )) ,collapse="\n") ), list(reader = readPlain) )
} 
#corpusBlogs <- getSingleFileCorpus( enUSBlogsFilepath )
#inspect(corpusBlogs)

#corpusNews  <- getSingleFileCorpus( enUSNewsFilepath ) 
#corpusTwitter <- getSingleFileCorpus( enUSTwitterFilepath )

# CREATE CORPUS ALL FILES IN DATASET
#corpusFull  <- Corpus( DirSource(enUSBaseFilePath), readerControl = list(reader=readPlain, language="en_US") )
#inspect(corpusFull)

# CREATE CORPUS SUBSET OF FILES
subsetPercentage <- 0.03
getDataSubset <- function( df, sp = subsetPercentage ) { sample(df, length(df) * sp )  }
dCombinedDataSubset <- c( getDataSubset( dBlogs ), getDataSubset( dNews ), getDataSubset( dTwitter ) )
filenameCombinedDataSubset <- paste0( dataBaseFilePath, "en_US.combined_subset.txt" )
if (file.exists(filenameCombinedDataSubset)) file.remove(filenameCombinedDataSubset)
fileCombinedDataSubset <- file(filenameCombinedDataSubset)
writeLines(dCombinedDataSubset, fileCombinedDataSubset)
close(fileCombinedDataSubset)
corpusCombinedDataSubset <- getSingleFileCorpus( filenameCombinedDataSubset )
inspect(corpusCombinedDataSubset)

# ------------------------------------------------------
# PREPROCESSING
# ------------------------------------------------------

# LOAD BANNED SWEAR WORD LIST
bannedWordList <- readLines( paste0( dataBaseFilePath, "swearWords.txt" ) )

# FUNCTION: GET-CORPUS-PREPROCESSED
getCorpusPreprocessed <- function( dCorpus ) {
  
  # TRANSFORM TO LOWERCASE
  dCorpus <- tm_map( dCorpus, tolower )
  
  # STRIP UNNECESSARY ITEMS
  dCorpus <- tm_map( dCorpus, stripWhitespace )
  dCorpus <- tm_map( dCorpus, removeNumbers )
  dCorpus <- tm_map( dCorpus, removePunctuation )
  
  # REMOVE BANNED, HIGHLY COMPLEX, NON-ENGLISH AND STOPWORDS
  dCorpus <- tm_map( dCorpus, function(x) iconv(x, "UTF-8", "ASCII", sub="") )
  dCorpus <- tm_map( dCorpus, removeWords, bannedWordList )  # PROFRANITY FILTER
  dCorpus <- tm_map( dCorpus, removeWords, stopwords("english") ) 
  
  # STEMMING ( WORD ROOT )
  dCorpus <- tm_map( dCorpus, stemDocument )
  
  # ENSURE PLAIN TEXT DOCUMENT
  dCorpus <- tm_map( dCorpus, PlainTextDocument )  
  
  customRemoveStopWords <- function(x) removeWords( x, stopwords("english") )
  customRemoveBannedWords <- function(x) removeWords( x, bannedWordList )
  customRemoveUnknownContent <- function(x) iconv(x, "UTF-8", "ASCII", sub="")
  
  #funcs <- list(
  #  tolower, removePunctuation, removeNumbers, stripWhitespace, 
  #  customRemoveBannedWords, customRemoveUnknownContent,
  #  customRemoveStopWords) 
  
  #dCorpus <- tm_map( dCorpus, FUN = tm_reduce, tmFuns = funcs)
  #dCorpus <- tm_map( dCorpus, stemDocument )
  #dCorpus <- tm_map( dCorpus, PlainTextDocument)  
  
  dCorpus # RETURN FILTERED CORPUS!
}



# NEED TO SPEED UP PRE-PROCESSING
#corpusBlogsPP <- getCorpusPreprocessed( corpusBlogs )
#inspect( corpusBlogsPP )
#corpusBlogsTDM <- getTermDocumentMatrix( corpusBlogsPP )
#corpusBlogsTDM

# NEED TO SPEED UP PRE-PROCESSING
#corpusFullPP <- getCorpusPreprocessed( corpusFull )
#inspect( corpusBlogsPP )

#corpusFullTDM <- getTermDocumentMatrix( corpusFullPP )
#corpusFullTDM
#corpusComboPP <- getCorpusPreprocessed( corpusCombinedDataSubset )
#inspect( corpusComboPP )

corpusComboPP <- getCorpusPreprocessed( corpusCombinedDataSubset )
inspect( corpusComboPP )

corpusComboTDM  <- TermDocumentMatrix( corpusComboPP )
corpusComboTDMx <- as.matrix( corpusComboTDM )

#class(corpusComboTDM)
#dim(corpusComboTDM)
#inspect(corpusComboTDM)

#terms <- Terms(corpusComboTDM)
#length(terms)
#unique(terms) 

#unigram  <- NGramTokenizer(corpusComboPP, Weka_control(min = 1, max = 1))
bigram   <- NGramTokenizer(corpusComboPP, Weka_control(min = 2, max = 2))
#trigram  <- NGramTokenizer(corpusComboPP, Weka_control(min = 3, max = 3))

#frequencyCombo <- rowSums(corpusComboTDMx)
#frequencyCombo <- sort(frequencyCombo, decreasing = TRUE)[1:100]
#names(frequencyCombo)

#barplot(head(frequencyCombo,25),main="Combo Corpus: Highest Word Frequency (Top 25)", ylab = "Frequency", cex.main=0.7, col = "orange", las = 2)