doRemoveWords <- function(string, words) {
  stopifnot(is.character(string), is.character(words))
  spltted <- strsplit(string, " ", fixed = TRUE) # fixed = TRUE for speedup
  vapply(spltted, function(x) paste(x[!tolower(x) %in% words], collapse = " "), character(1))
}