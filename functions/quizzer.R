source(paste0(projectDir, "quiz/tester_quiz_common.R"))
source(paste0(projectDir, "quiz/tester_quiz_2.R"))
source(paste0(projectDir, "quiz/tester_quiz_3.R"))

quizzer <- function( quiz, question ) {
  cat("-----------------------------------------------------------------\n")
  cat("PREDICTION:\n")
  resultPrediction <- doStupidBackOffPredict(quiz[[question]]@question)
  print(resultPrediction)
  cat("----------\n")
  cat("ANSWERS:\n")
  print(quiz[[question]]@answer)
}

#quizzer( q3, 7)
