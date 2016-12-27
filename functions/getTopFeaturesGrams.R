getTopFeaturesGrams <- function( xDfmSparse, nCount ) {
  tf = topfeatures(xDfmSparse, nCount)
  dfTopFeatures = data.frame(tf)
  dfTopFeatures$ngrams <- rownames(dfTopFeatures) 
  if (nCount > 1) {
    dfTopFeatures$ngrams <- gsub('_', ' ', dfTopFeatures$ngrams)
    dfTopFeatures <- dfTopFeatures %>% 
      separate(ngrams, into = c("firstterms","lastterm"), sep = ' (?=[^ ]+$)')
  }
  dfTopFeatures
}