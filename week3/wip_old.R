tm findAssocs. 
#tm removeSparseTerms


#corpA <- tm_map(mycorpus, wordStem2);
#corpB <- Corpus(VectorSource(corpA));

#corpusCombinedDataSubset <- getSingleFileCorpus( filenameCombinedDataSubset )
#inspect(corpusCombinedDataSubset)

#source(paste0(funcDir, "getCorpusPreprocessed.R"))
#corpusComboPP <- getCorpusPreprocessed( corpusCombinedDataSubset )
#inspect( corpusComboPP )

#corpusComboTDM  <- DocumentTermMatrix( corpusComboPP )
#as.matrix( corpusComboTDM )
#corpusComboTDMSparsed <- removeSparseTerms(corpusComboTDM, 0.05)
#as.matrix(corpusComboTDMSparsed)

#source(paste0(funcDir, "getNgrams.R"))
#unigram <- getNgrams( corpusComboPP, 1 )
#bigram <- getNgrams( corpusComboPP, 2 )
#trigram <- getNgrams( corpusComboPP, 3 )
#quadgrams <-getNgrams( corpusComboPP, 4 )

#splitNgrams <- strsplit(as.character(dfGrams4$ngrams), ' (?=[^ ]+$)', perl=TRUE)
#dfGrams4After <- with(dfGrams4, data.frame(tf = tf, ngrams = ngrams))
#dfGrams4After <- cbind(dfGrams4After, data.frame(t(sapply(splitNgrams, `[`))))
#names(dfGrams4After)[4:5] <- c("firstterms","lastterm")


https://github.com/ThachNgocTran/KatzBackOffModelImplementationInR/blob/master/calculateDiscount.R