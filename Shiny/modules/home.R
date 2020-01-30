
home <- function(input, output, session, n){ 
  
  #-----------------------------------------------------------------------
  #   2. Output to UI
  
  output$job_count <- renderText({
    paste("Jobs Analysed: ", n)
  } 
)
}
