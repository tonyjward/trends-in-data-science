
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
  
   for (i in 1:2){
  #for (i in 1:resultNumber-1){
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
              file = file.path('/home/rstudio/Scraping/ROutput',paste0(searchTermFile,Sys.Date(),".txt")),
              sep = "\t",
              row.names = FALSE) 

}



