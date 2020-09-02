        # RUNNING SHINY OVER A NETWORK FROM A LOCAL MACHINE/SERVER
        # TYPE THIS INTO THE CONSOLE TO RUN SHINY -> shiny::runApp('Project.NoAudit_Shiny',host="0.0.0.0",port=5050) 
        # Users can then goto the following link in their web browser: http://192.168.38.167:5050
        # If using another machine to host the app then use http://[IP_ADDRESS]:5050
        
        CapSent <- function(threshold = 0.1, df){ 
                #### Function: Capital Sentiment Analysis ####
                # Created: June 2018
                # Author: Nick Dawe
                # Version: 1.0
                # Descrition: Determine Capital 'sentiment' from a customised dictionary called "CapDict". 
                #             This function audits the Project Ledger Transactions from PPA's TechOne ERP and identifies OPEX
                #             transactions (against 'M' Codes) that should have been Capitalised. A look up dictionary has been
                #             created and stored in the working directory which is used to determine "Capital Sentiment".
                #             The function is called via Shiny to display in an interactive app on the Power BI Server.
                #
                # Arguments: 'threshold' is the threashold to assign CAPEX value of 1. Default value is 0.1
                #            'df' is the dataframe (csv format) containing the TechOne Project Ledger Transactions to be analysed
                #            The format of df should contain (as a minimum) the following header information:
                #        
                #                       ## ############################################### ##
                #                       Narrative 1 #  Project No  # Document Type # Amount
                #                       ## ############################################### ##
                #                       #  COMMENTS # C or M CODE  #   E.G APINVP  #  $$$        
                #
                #
                # Version Control:
                # Version: 1.1
                #       Updated: July 2019
                #       Changes: 1) Changed the cut-off value (line 64) to $0 since transactions are often disected 
                #                (broken down) into multiple lines meaning that the total amount is not captured.
                #                2) Added pacman package for automated package management.
                #
                # Version: 1.2
                #       Updated:
                #       Changes: 1)
                #
                #
                ##### 
                
                # Check package manager and load
                if (!require("pacman")) {
                        install.packages("pacman")
                        require("pacman")
                } else {
                        require("pacman")
                }
                pacman::p_load("sentimentr", "DT")
                
# Determine Capital Sentiment using sentimentr                 
               # Read in the Dictionary of Capital Words stored in the working folder:
                CapDict <- read.csv('CapitalCostDictionary.csv')
               # df <- read.csv("CY PL Transactions.csv"); threshold <- 0.2 # Uncomment this line for testing.
                # 
      
                # Create a keyword dictionary from the CSV file
                key <- data.frame(
                        words = CapDict$words,
                        polarity = CapDict$polarity,
                        stringsAsFactors = FALSE
                )
                
                key <- as_key(key)
                
                # Commence Analysis
                capsent <- df
                capsent$Narrative.1 <- as.character(capsent$Narrative.1)
                Encoding(capsent$Narrative.1) <- "latin1" # Convert from UTF-8 as this generates an error in get_sentances without doing so
                x <- get_sentences(capsent$Narrative.1)
                # sentiment(x)
                # extract_sentiment_terms(x,polarity_dt = key, hyphen = "") # View key terms used
                
                y<- sentiment_by(x, polarity_dt = key, hyphen = "") # Apply the dictionary
                #highlight(y,"OPEX_Audit.html",open = TRUE)
                #highlight(sentiment_by(x,polarity_dt = key, hyphen = "", question.weight = 0)) # Prepare a highlighted HTML document
                capsent$CapSentiment <- y$ave_sentiment # Apply the sentiment scores to the dataframe
                capsent$CapSentiment_Cl <- 0 # Create the sentiment class vector
                capsent$CapSentiment_Cl[capsent$CapSentiment >= threshold] <- 1 # Assign 1 where sentiment is above the threashold
                capsent$CapSentiment_Cl[capsent$CapSentiment <= threshold] <- 0
                capsent$CapSentiment_Cl[grepl('^C', capsent$Project.No)]<- 1 # Cost Codes starting with `C` are capital and get value 1
                
                #capsent$Amount<-as.numeric(as.character(capsent$Amount)) 
                capsent$Amount<-as.numeric(gsub(",","",capsent$Amount)) # Remove the ',' from excel numeric data. 
                capsent <- subset(capsent,capsent$Amount > 0) # Normally assets greater than $5k however transactions are broken down into sep lines
                capsent <- capsent[order(-capsent$CapSentiment), ] # Sort the data by Sentiment score in Descending Order
                #write.csv(capsent, "OPEX_Analysis.csv")
                
                capsent$Document.Type<- as.character(capsent$Document.Type)
                
                capsent<-subset(capsent, grepl('^M', capsent$Project.No) == TRUE & capsent$Document.Type == "APINVS" | 
                                        capsent$Document.Type == "APINVI" | capsent$Document.Type == "APINVP" | 
                                        capsent$Document.Type == "$APINVCE") # Filter by M Codes and document type
                #write.csv(capsent, "OPEX_To_Check.csv")
                #syslog <- t(as.matrix(Sys.getenv())) # Create system data
                #syslog <- cbind(Sys.time())
                #write.table(syslog, "syslog.csv", sep=",",col.names = F, append = T) # Append the data to an existing log file
                #write.csv(syslog,"syslog.csv")
                #Sys.getenv('USERNAME')

                # The file to output (capsent) needs to be positioned at the end of the function otherwise it will not work.
                capsent <- capsent
                

        }
        
