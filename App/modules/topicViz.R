topicViz <- function(input, output, session, json){
  output$plot <- renderVis({
    json()
  })
}