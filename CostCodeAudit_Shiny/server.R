# Define server logic 

options(shiny.maxRequestSize=30*1024^2) # Increase upload size limit to 30Mb

server <- function(input, output) {
  
  temp_df <- reactiveValues(df_data = NULL)
  temp_df2 <- reactiveValues(df_data = NULL)
  
  # Create a system log
  #syslog <- t(as.matrix(Sys.getenv('USERNAME'))) # Create system data
  #syslog <- as.data.frame(syslog)
  #syslog <- cbind(syslog,as.POSIXlt(Sys.time()), "OPEXAudit")
  #write.table(syslog, "syslog.csv", sep=",", col.names = F, append = T) # Append the data to an existing log file
  # Write the system log information to file
  #write.table(syslog, "//pe-file01/PPA_SHARED/BI Data/RStudio/Shiny/syslog.csv", sep=",", col.names = F, append = T)
  
  
  output$contents <- DT::renderDataTable({
    
      req(input$file1)
      temp_df$df_data <- read.csv(input$file1$datapath, stringsAsFactors = FALSE, header = TRUE, skip = 0)      # Import the selected transaction data
                                                                                                                # The 'skip' argument removes the first row.
  
      

      temp_df$df_data # Returns the data to the screen
    
    
  }, options = (list(pageLength = 5, scrollX = TRUE)))
  
  output$contents2 <- DT::renderDataTable({
    
    
    temp_df2$df_data
    
    
  }, options = (list(pageLength = 5, scrollX = TRUE)))

  observeEvent(input$button,{
    if(!is.null(temp_df$df_data)){
      temp_df2$df_data <- CapSent(threshold = 0.1, temp_df$df_data)
      
      output$modify <- renderUI({
        tagList(
          h2("RESULTS"),
          DT::dataTableOutput("contents2")
        )
      })
      
      output$downloadButton <- renderUI({
        downloadButton("downloadData", "Download Results")

      })
    }else{
      showNotification("No data was uploaded")
    }

  })
  
  
  
  output$downloadData <- downloadHandler(
    
    filename = function() { 
      paste("M_Code_Audit-", Sys.Date(), ".csv")#, sep="")
    },
    content = function(file) {
      write.csv(temp_df2$df_data, file)

    })
  
}


