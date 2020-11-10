ui <- fluidPage(
        tags$head(tags$link(rel="shortcut icon", href="favicon.ico")), # Add the favicon,
        
  # App title ----
  titlePanel("OPEX Audit"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
  
    # Sidebar panel for inputs ----
    sidebarPanel(
            h4("Introduction"),
            hr(),
            p("This Audit tool is used to review Operational Expenditure (OPEX) cost transactions generated from TechOne and determine
                     if they should be Capital Expenditure (CAPEX)."),
            p("The tool uses a word list (referred to as a Lexicon) which contains a list of capital and non-capital wording 
                with an associated score and compares the input comments against these to assess whether or not the transactions 
                appear to be capital in nature."),
            
            p("Click ", a(target="_blank","HERE", href="CapitalCostDictionary.csv"), " to 
                     open a copy of the word list."), # Any documents should be saved to the www folder to open via links.

            p("Start by selecting a CSV file which contains the transactions for review."),
            
            br(),
            h4("Loading Your Data"),
            hr(),
            
            p("The input CSV file should contain the following column names (as a minimum):"), 
                     
            p("'Narrative 1', 'Project No', 'Document Type' and 'Amount'."),
            
            p("Note that column names are case sensitive so ensure the input file column names match exactly as shown above. If using the 'Project Ledger Transaction data' report from TechOne, you will not need to modify the data. 
              The current file upload limit is 30Mb."),
            
            p("An example input file can be downloaded ", a(target="_blank","HERE", href="Transactions_Example Input File.csv"), 
              ". Save this file to your desktop and browse to it to try out the tool."), # Any documents should be saved to the www folder to open via links.
            
      # Input:  ----
      fileInput("file1", "Choose CSV File",
                multiple = TRUE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      actionButton("button", "Audit Data"),
      hr(),
      uiOutput("downloadButton"),
      helpText("The downloaded data will open in Excel and show the Capital 'sentiment' for each transaction
                             based on the word list.")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
        
        # img(src='PPA LOGO_PNG.png', align = "right"),
      img(src='logo.png', align = "right"),
      h2("ORIGINAL DATA"),
      DT::dataTableOutput("contents"),
      br(),
      uiOutput("modify")
      
      
    )
  )
)