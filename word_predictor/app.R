#
# Shiny app prepared for the Coursera Capstone Project 
#

library(shiny)

source("word_predictor.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Word Predictor - January 2020"),
    
    sidebarLayout(
        sidebarPanel(
            helpText(h4("Introduction"),
                "This Shiny App forms part of the Data Science Capstone Project to develop a Natural Language Processing 
                (NLP) word prediction tool.",
            p(),
                "The Word Predictor takes words entered by the user and predicts the next word based on a 
                corpus of documents such as Twitter feeds, News, and Blogs.",
            p(),
            h4("The Model"),
            "The `quanteda` package was used to process text data.
            The model was built by sampling the three datasets and combining them into one corpus.",
            p(),
            "Three n-grams were developed consisting of 2, 3 and 4 grams in the model building. All of which are combined into a list and
            loaded into this Shiny application.",
            p(),
            "The four most frequently occurring predicted end words are presented in the Action buttons in descending order of frequency.",
            h4("Instructions"),
                "The default sentence can be modified by typing over it, or predictions made by clicking on 
                the relevant Action button.",
            p(),
            "Do not add a space after the last word - if you do, the predictor will not interpret it.",
            p(),
            "The text box size can be increased by dragging the handle in the lower right corner.",
            h4("More Information"),
            "More information including the code for this app can be found on my",
            tags$a(href="https://github.com/Dawsey/Data_Science_Capstone_Project", "Github page.")),
        ),
        
        mainPanel(
            #textInput("caption", "Caption", "Once upon a time"),
            
            textAreaInput("caption", "Enter your words here:", value = "Once upon a time", width = NULL, height = NULL,
                          cols = NULL, rows = 1, placeholder = NULL, resize = "vertical"),
            #div(style="display:inline-block", uiOutput("my_button_1")),
            h5("Recommended Prediction"),
            uiOutput("my_button_1"),
            h5("Alternative Suggestions"),
            div(style="display:inline-block", uiOutput("my_button_2")),
            div(style="display:inline-block", p("or")),
            div(style="display:inline-block", uiOutput("my_button_3")),
            div(style="display:inline-block", p("or")),
            div(style="display:inline-block", uiOutput("my_button_4")),
        )
    )
)

server <- function(input, output, session) {

    my_clicks <- reactiveValues(data = NULL)

    output$my_button_1 <- renderUI({
        actionButton("action1", label = predict_word(input$caption)[1])
    })
    
    observeEvent(input$action1, {
       my_clicks$data <- predict_word(input$caption)[1]
       
           updateTextInput(session, "caption", value = paste(input$caption, my_clicks$data))

    })
    
    output$my_button_2 <- renderUI({
        actionButton("action2", label = predict_word(input$caption)[2])
    })
    
    observeEvent(input$action2, {
        my_clicks$data <- predict_word(input$caption)[2]
        
        updateTextInput(session, "caption", value = paste(input$caption, my_clicks$data))
        
    })
    
    output$my_button_3 <- renderUI({
        actionButton("action3", label = predict_word(input$caption)[3])
    })
    
    observeEvent(input$action3, {
        my_clicks$data <- predict_word(input$caption)[3]
        
        updateTextInput(session, "caption", value = paste(input$caption, my_clicks$data))
        
    })
    
    output$my_button_4 <- renderUI({
        actionButton("action4", label = predict_word(input$caption)[4])
    })
    
    observeEvent(input$action4, {
        my_clicks$data <- predict_word(input$caption)[4]
        
        updateTextInput(session, "caption", value = paste(input$caption, my_clicks$data))
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

#runApp(display.mode = "showcase")
