library(shiny)

shinyUI(
  
  # DEFINE PAGE STYLE
  fluidPage(
    
    titlePanel("Typeahead Next-Word Predictor"),
    
    # TITLE BAR SECTION
    fluidRow(
      (column 
        (width = 12, 
        offset = 0,
        style='padding:18px;',
        h4("by Wesley Small (smallwesley)", style="color:purple"), 
        p("This application demonstrates typeahead/next-word predictions derived from an extensive N-GRAM anaylsis of text documents."),
        p("Match a n-word character string with the appropriate n+1 gram entry in the N-gram Frequency Table. For example, a two-word string should be matched with its corresponding entry in a tri-gram table. If there is a match, propose high frequency words to the user. Continuing the previous example, a match should be the last word of the n-gram.")
        )
      )
    ), # fluidRow()
    
    # DEFINE LAYOUT
    sidebarLayout(
      
      # SIDE BAR
      sidebarPanel(
        p("BACKGROUND: "),
        p("For this particular applications, I have modeled set of N-Grams (unigrams to quintgram) 
          from a given body Blogs posts, News articles and Twitter posts."),
        hr(),  
        p(" n-gram model we only use a random-subset (2%) of the entire corpus. 
          Using text operations, we tidy this text to ensure we only have word features devoid of 
          unecessary nonalpha & non ASCII characters."),
        hr(),
        p("The primary algorithm implemented to predict next word terms 
          is from an approach called \"Stupid Backoff\" in which scoring including a
          discount multiplier to account for unseen words.")
      ), # sidebarPanel()

      # MAIN PANEL
      mainPanel(
        h4("INSTRUTIONS:"),
        p("Type words/sentence within the text-field below. 
           Click the \"PREDICT\" button. 
           Next word terms will appear in the select-input control."),
        fluidRow(
          column(6,textInput("sentenceInput",label="")),
          column(4,uiOutput("sentenceTokens"))
        ),
        submitButton("PREDICT"),
        hr(),
        h5("PREDICTION DETAIL:"),
        div( uiOutput("predictions", align="center"))
        
      ) # mainPanel()
      
    ) # sidebarLayout()

  ) # fluidPage()
  
) # shinyUI()

  