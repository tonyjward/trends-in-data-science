# https://shiny.rstudio.com/articles/sql-injections.html
# In summary, you should always sanitize your user-provided inputs. 
# If they’re numbers, coerce them to the integer or the numeric class. 
# If they’re strings that go into a SQL query, use sqlInterpolate(). 
# If it’s something more complicated, make sure you process it in a way such that a SQL injection is impossible.

loadData <- function(input, output, session){ 
  
  #-----------------------------------------------------------------------
  #   2. Output to UI
  
  output$tbl <- DT::renderDataTable({

    datatable(dt[,c( "job_type",
                     "jobResultsTitle",
                     "skills",
                     "rate",
                     "jobResultsLoc", # if you want country as well, use location
                     "posted_date"), with = FALSE],
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
