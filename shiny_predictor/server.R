library(shiny)

projectDir = ""
dataDir   <- paste0( projectDir, "data/")

# LOAD PREDICT 
source( paste0(projectDir, "predict.R"))

shinyServer(function(input, output, session) {

  # ---------------------------
  # SET HANDLE REACTIVE INPUT 
  executePrediction <- reactive({
    # PERFORM PREDICTION BASED ON INPUT
    
    if ( !is.null(input$token) && nchar(input$token ) > 0 ) {
      combinedText <- paste(input$sentenceInput, input$token)
      print(combinedText)
      updateTextInput(session,"sentenceInput", label = "", value = combinedText)
    }
    
    if ( nchar(input$sentenceInput ) > 0 )
      doStupidBackOffPredict( input$sentenceInput )
    else 
      ""
  })

  # ---------------------------
  # RENDER OUTPUT
  
  # UPDATE SELECTABLE TOKENS
  output$sentenceTokens <- renderUI({
    if (nchar(input$sentenceInput) == 0 ) {
      selectInput('token', '', c(""))
    }
    else {
      predictionDF <- executePrediction()
      if( nrow(predictionDF@output) == 0) {
        selectInput('token', '', c(""))
      } else {
        selectInput('token', '', predictionDF@output$token)
      }
    }
  }) # renderUI() 
  
  # C: PREDICTION TABLE RENDERING
  output$predictions <- renderUI({
    if( nchar(input$sentenceInput) == 0) {
      return("---")
    }
    else {
      predictionDF <- executePrediction()
          
      if( is.null(predictionDF) || nrow(predictionDF@output) == 0) {
        return("---")
      }
      tableOutput("predictionsTable")
    }
  }) # renderUI()
  
  output$predictionsTable <- renderTable({
    predictionDF <- executePrediction()
    predictionDF@output
  }) # renderTable()

}) 