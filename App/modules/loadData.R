# https://shiny.rstudio.com/articles/sql-injections.html
# In summary, you should always sanitize your user-provided inputs. 
# If they’re numbers, coerce them to the integer or the numeric class. 
# If they’re strings that go into a SQL query, use sqlInterpolate(). 
# If it’s something more complicated, make sure you process it in a way such that a SQL injection is impossible.

loadData <- function(input, output, session, combinations){ 
  

  #-----------------------------------------------------------------------
  #   2. Output to UI
  
  output$tbl <- DT::renderDataTable({

    datatable(dt, 
              filter = "top",
              options = list(
                autoWidth = TRUE,
                scrollX = TRUE, # required to change column length https://github.com/rstudio/DT/issues/29
                columnDefs = list(list(width = '2000px', targets = 10)))) 
  } 
)
}
