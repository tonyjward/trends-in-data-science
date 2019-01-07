tools <- function(input, output, session, jobData){
  
  # Time Series Bar Plot
  output$plot <- renderPlot({
    ggplot(data = jobData, aes_string(x = "yearMonDay", fill = "Python_R")) + "geom_bar"()
  })
  
  
  # Comparison Table
  output$table <- renderTable({
    split <- table(jobData$Python, jobData$R)
    proportions <- (prop.table(split) * 100) %>% round()
    colnames(proportions) <- c("NO R", "R")
    rownames(proportions) <- c("NO Python", "Python")
    proportions
  })
  
}