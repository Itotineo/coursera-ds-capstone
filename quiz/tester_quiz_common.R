setClass("Quiz", slots = list(question = "character", answer = "character"))
addQA <- function(l, n, q, a) { 
  l[[n]] <- new ("Quiz", question = q, answer = a)
  l
}
