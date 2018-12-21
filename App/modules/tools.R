tools <- function(input, output, session, jobData){
  output$plot <- renderPlot({
    ggplot(data = jobData, aes_string(x = "yearMonDay", fill = "Python_R")) + "geom_bar"()
  })
}