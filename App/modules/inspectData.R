
inspectData <- function(input, output, session, jobData){ 
  
  #-----------------------------------------------------------------------
  #   2. Output to UI
  
  output$tbl <- DT::renderDataTable({

    datatable(jobData()[order(-`Posted Date`),c( "Type",
                     "Title",
                     "text_field",
                     "Salary",
                     "Location", # if you want country as well, use location
                     "Posted Date"), with = FALSE],
              filter = "top",
              options = list(
                autoWidth = TRUE,
                scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
                columnDefs = list(list(width = '1000px', targets = 3)))
                #lengthMenu = c(5,10,15,20))
              ) 
  } 
)
}
