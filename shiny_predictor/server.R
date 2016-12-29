library(shiny)

projectDir = ""
dataDir   <- paste0( projectDir, "data/")

# LOAD PREDICT 
source( paste0(projectDir, "predict.R"))
source( paste0(projectDir, "cleanseText.R"))

shinyServer(function(input, output, session) {

  # ---------------------------
  # SET HANDLE REACTIVE INPUT 
  executePrediction <- reactive({
    # PERFORM PREDICTION BASED ON INPUT
    
    if ( !is.null(input$token) && nchar(input$token ) > 0 ) {
      combinedText <- paste(input$sentenceInput, input$token)
      #print(combinedText)
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
        selectInput('token', '', c(predictionDF@output$token,""))
      }
    }
  }) # renderUI() 
  
  # observe({
  #   predictionDF <- executePrediction()
  #   if( nchar(input$sentenceInput) > 0 && !is.null(predictionDF) && nrow(predictionDF@output) > 0) {
  #     #choicesList <- c(input$sentenceInput, paste(input$selectableInputTokens, predictionDF@output$token)) 
  #     choicesList <-  c(input$sentenceInput, paste(input$sentenceInput,predictionDF@output$token))  
  #     updateSelectizeInput(session, "selectableInputTokens", "", choicesList)
  #   }
  # })
  
  # C: PREDICTION TABLE RENDERING
  output$predictions <- renderUI({
    if( nchar(input$sentenceInput) == 0) {
      return("")
    }
    else {
      predictionDF <- executePrediction()
          
      if( is.null(predictionDF) || nrow(predictionDF@output) == 0) {
        return("")
      }
      tableOutput("predictionsTable")
    }
  }) # renderUI()
  
  output$predictionsTable <- renderTable({
    predictionDF <- executePrediction()
    predictionDF@output
  }) # renderTable()

  # D: PREDICTION ORIGINAL TEXT
  output$predictionInput <- renderUI({
    if( nchar(input$sentenceInput) == 0) {
      return("")
    }
    else {
      predictionDF <- executePrediction()
      HTML(paste0("<p><b>ORIGINAL:</b><br/>\"", predictionDF@input,"\"</p>"))
    }
  }) # renderUI()

  # E: PREDICTION ABSTRACT TEXT
  output$predictionAbstract <- renderUI({
    if( nchar(input$sentenceInput) == 0) {
      return("")
    }
    else {
      predictionDF <- executePrediction()
      HTML(paste0("<hr/><p><b>CLEANSED:</b><br/>\"", predictionDF@abstract,"\"</p>"))
    }
  }) # renderUI()  
  
}) 