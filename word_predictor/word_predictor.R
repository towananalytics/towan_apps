library(stringr)
library(dplyr)

# Load the model
#load("./Model/combi_list.Rds") 
load("combi_list.Rds")

predict_word <- function(text) {
  
  start.words <- tolower(text)
  
  # Word count function taken from:
  # https://stackoverflow.com/a/55396237/8158951 takes into account hyphens and appostrophies
  words <- function(txt) { 
    length(attributes(gregexpr("(\\w|\\w\\-\\w|\\w\\'\\w)+", txt)[[1]])$match.length) 
  }
  
  last.x.words <- as.numeric(ifelse(words(start.words) >= 3, 3, words(start.words)))  #Extract last x words from user entered prediction
  last.words <- paste(word(start.words, -last.x.words:-1), 
                      collapse = " ") # last x words
  start.words.vec <- gsub(" ", "_", last.words)
  first.pattern <- paste0("^", start.words.vec, "_")
  
  # Filter the applicable n-gram from the list of 2, 3 and 4-gram dtm
  subset <- comb.list[[last.x.words]] %>% 
    filter(stringr::str_detect(ngram, first.pattern)) %>% # find the starting word
    arrange(desc(frequency)) %>% # Sort the counts in descending order
    ungroup() %>%
    slice(1:4) # Return the first 4 rows
  
  # The following lines determine the legth of predicton
  # If subset has no predictions this is due to the tri-gram being too complicated/non-matching
  # The script then matches the last word "last.x.words = 1":
  if(nrow(subset) > 0) { # If length of subset is > 0 then return predicted words
         
    gsub(paste0(gsub(" ", "_", last.words, fixed = TRUE), "_"), 
              "", as.character(subset$ngram))
    
  } else { # The length is 0 i.e. there are no matching predictions for 3 words.
           # The script then uses the last word to predict on.
           # paste("No Prediction")
    last.x.words <- 1
    last.words <- paste(word(start.words, -last.x.words:-1),
                        collapse = " ") # last x words
           
    start.words.vec <- gsub(" ", "_", last.words)
    first.pattern <- paste0("^", start.words.vec, "_")
           
           # Filter the applicable n-gram from the list of 2, 3 and 4-gram dtm
    subset <- comb.list[[last.x.words]] %>%
      filter(stringr::str_detect(ngram, first.pattern)) %>% # find the starting word
      arrange(desc(frequency)) %>%
      ungroup() %>%
      slice(1:4)
           
    gsub(paste0(gsub(" ", "_", last.words, fixed = TRUE), "_"),
         "", as.character(subset$ngram))
  }
 
}

predict_word("once upon a time")
predict_word("you'd like to")
predict_word("on the last day of christmas")
