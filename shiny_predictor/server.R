library(shiny)
library(shinythemes)
#library(googleVis)

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
    searchText <- input$sentenceInput 
      
    if ( !is.null(input$token) && nchar(input$token) > 0 && !(input$token == "{predictions-below}") ) {
      searchText <- paste(input$sentenceInput, input$token)
      updateTextInput(session,"sentenceInput", label = "", value = searchText)
    }
    
    if ( nchar( searchText ) > 0 )
      doStupidBackOffPredict( searchText )
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
        selectInput('token', '', c("{predictions-below}",predictionDF@output$token))
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
  }, digit = 5) # renderTable()
  
  #output$predictionsTable <- renderGvis({
  #  predictionDF <- executePrediction()
  #  predictionDF@output
  #  gvisTable(predictionDF@output);
  #})

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