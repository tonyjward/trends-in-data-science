
inspectData <- function(input, output, session, jobData){ 
  
  #-----------------------------------------------------------------------
  #   2. Output to UI
  
  output$tbl <- DT::renderDataTable({

    datatable(jobData[job_type == input$job_type, .(doc_id, Title, text, Salary, salaryMax, Location, PostedDate)],
              filter = "top",
              options = list(
                autoWidth = TRUE,
                scrollX = TRUE # required to change column length https://github.com/rstudio/DT/issues/29
                #columnDefs = list(list(width = '1000px', targets = 3)))
                #lengthMenu = c(5,10,15,20))
              ), rownames = FALSE,
              colnames = c("ID" = "doc_id",
                           "Title" = "Title",
                           "Description" = "text",
                           "Salary" = "Salary",
                           "Salary (Max)" = "salaryMax",
                           "Location" = "Location",
                           "Posted Date" = "PostedDate")) %>% formatDate("Posted Date",
                                                                          method = "toLocaleString")
  } 
)
}
