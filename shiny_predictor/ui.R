library(shiny)
library(shinythemes)
library(googleVis)

shinyUI(
  
  # DEFINE PAGE STYLE
  ui = fluidPage( 
    theme = shinytheme("slate"),
    
    # TITLE
    titlePanel("Typeahead Next-Word Predictor"),
    
    # TEST THEMES
    #shinythemes::themeSelector(),
    
    # TOP BAR CONTENT
    fluidRow(
      column 
        (width = 12, 
        offset = 0,
        style='padding:18px;',
        h4("by Wesley Small (smallwesley)", style="color:purple"), 
        p("This application demonstrates typeahead/next-word predictions derived from an extensive N-GRAM anaylsis of text documents."),
        p("Match a n-word character string with the appropriate n+1 gram entry in the N-gram Frequency Table. For example, a two-word string should be matched with its corresponding entry in a tri-gram table. If there is a match, propose high frequency words to the user. Continuing the previous example, a match should be the last word of the n-gram.")
        )
      
    ), # fluidRow()
    
    # DEFINE LAYOUT
    sidebarLayout(
      
      # SIDE BAR
      sidebarPanel(
        h5("BACKGROUND: "),
        p("For this particular application, I have modeled set of N-Grams (unigrams to quintgram) 
          from a given body Blogs posts, News articles and Twitter posts."),
        hr(),  
        p(" n-gram model we only use a random-subset (5%) of the entire corpus. 
          Using text operations, we tidy this text to ensure we only have word features devoid of 
          unecessary nonalpha & non ASCII characters."),
        hr(),
        p("The primary algorithm implemented to predict next word terms 
          is from an approach called \"Stupid Backoff\" in which scoring including a
          discount multiplier to account for unseen words.")
      ), # sidebarPanel()

      # MAIN PANEL
      mainPanel(
        h5("INSTRUTIONS:"),
        p("Type words/sentence within the text-field below. 
           Click the \"PREDICT\" button. 
           The predicted word terms will appear in the combo dropdown box."),
        textInput("sentenceInput",label=""),
        tags$head(tags$style(type="text/css", "#sentenceInput {width: 550px}")),
        uiOutput("sentenceTokens"),
        tags$head(tags$style(type="text/css", "#token {width: 550px}")),
        submitButton("PREDICT"),
        hr(),
        
        fluidRow(
          column( 
            width = 10,
            offset = 0,
            style='padding:1px;',
            h5("PREDICTION CLASS DEBUG: ")
          ),
          column( 
            width = 5,
            offset = 0,
            style='padding:1px;',
            
            uiOutput("predictionInput", align="left"),
            uiOutput("predictionAbstract", align="left")
          ),
          column( 
            width = 5,
            offset = 0,
            style='padding:1px;',
            uiOutput("predictions", align="right")
          )
        )
      ) # mainPanel()
      
    ) # sidebarLayout()

  ) # fluidPage()
  
) # shinyUI()

  