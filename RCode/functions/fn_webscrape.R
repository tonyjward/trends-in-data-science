# jobserve.R
# Author: Tony Ward
# Date: 27 November 2017

# Purpose: Manipulate data as needed

# Contents:
#   1. When using this TEMPLATE, note here in a numbered list, what the program does.
#      Will vary by client but typically something like: 
#   _. Load data required
#      followed by options from template and / or manipulation specific to the client.

# Notes: Add to template for 02a
#        1 below: Stack datasets section along with various checks   
#        2 below: Change text for header for 2
#        3 below: New code based on TW - change in template
#        4 below: Add section to deal with 
#                 manually changing to NA things that are missing levels
#        6 below: Add new code to find character columns
#        


#---------------------------------------------------------------------
#   _. Required Libraries




#---------------------------------------------------------------------
#  1. Establish Connection

fn_webScrape <- function(searchTerm){
  # searchTerm <- '"data scientist"'

  remDr <- remoteDriver(remoteServerAddr = "selenium",
                        port = 4444L,
                        browser = "chrome")
  
  remDr$open(silent = TRUE)
  
  remDr$navigate("https://www.jobserve.co.uk")
  
  # remDr$screenshot(display = TRUE)
  
  #---------------------------------------------------------------------
  #  1. Search for data scientist
  
  
  
  # clear entries just in case
  webElem <- remDr$findElement(using = "id", value = "txtKey")
  webElem$clearElement()
  
  webElem <- remDr$findElement(using = "id", value = "txtLoc")
  webElem$clearElement()
  
  # remDr$screenshot(display = TRUE)
  
  # send search string to keyword text box
  webElem <- remDr$findElement(using = "id", value = "txtKey")
  webElem$sendKeysToElement(list(searchTerm, key = "enter"))
  Sys.sleep(runif(n=1, min=1, max = 4))
  # remDr$screenshot(display = TRUE)
  
  #---------------------------------------------------------------------
  #  2. Parse Output
  
  # grab html
  htmlOutput<- read_html(remDr$getPageSource()[[1]])
  
  # # save html to file (optional)
  # sink("htmlOutput.txt")
  # htmlOutput
  # sink()
  
  tagNames <- c(".jobSelected .jobResultsTitle", ".jobSelected .jobResultsSalary", ".jobSelected .jobResultsLoc", ".jobSelected .jobResultsType",
                "#td_jobpositionlink", "#td_location_salary", "#td_job_type", "#td_last_view",
                "#md_skills", "#md_location", "#md_industry", "#md_category", "#md_duration", "#md_start_date", "#md_rate",
                "#md_recruiter", "#md_contact", "#md_ref", "#md_posted_date", "#md_permalink",
                "#md_company_summary")
  
  trim <- function(x) gsub("^\\+\r\n|\r|\n|\t","",x) ##cleaning text
  
  grabText <- function(x){
    htmlOutput %>%
      html_nodes(x) %>%
      html_text %>%
      trim()
  }
  
  result <- lapply(tagNames, grabText)
  
  # tidy up names
  names(result) <- tagNames %>% 
    gsub(".jobSelected|\\.| |#|td_|md_","",.) %>%
    make.names()
  
  # convert to data.table
  allDataDT <- as.data.table(result)
  
  #---------------------------------------------------------------------
  #  2. Cycle through
  
  resultNumber <- grabText(".resultnumber") %>% 
    gsub(",","",.) %>% # remove commas
    as.numeric()
  
  # for (i in 1:2){
  for (i in 1:resultNumber-1){
    # press down arrow key
    remDr$sendKeysToActiveElement(list(key = 'down_arrow', 
                                       key = 'down_arrow', 
                                       key = 'enter')
    )
    
    # wait for screen to refresh
    Sys.sleep(2)
    
    # grab html
    htmlOutput<- read_html(remDr$getPageSource()[[1]])
    
    result <- lapply(tagNames, grabText)
    
    # tidy up names
    names(result) <- tagNames %>% 
      gsub(".jobSelected|\\.| |#|td_|md_","",.) %>%
      make.names()
    
    # convert to data.table
    resultDT <- as.data.table(result)
    
    # bind result
    allDataDT <- rbind(allDataDT, resultDT, fill = TRUE )
  }
  
  
  #---------------------------------------------------------------------
  #  3. Save and exit
  
  
  searchTermFile <- gsub('"', "",searchTerm)
  searchTermFile <- gsub(" ","_", searchTermFile)
  
  write.table(allDataDT,
              file = file.path('/home/rstudio/ROutput',paste0(searchTermFile,Sys.Date(),".txt")),
              sep = "\t",
              row.names = FALSE) 

}



