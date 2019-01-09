homeUI <- function(){
  tagList(
    h1("Data Science: Market Trends"),
    img(src = "datascience.png", width = 500, height = 400),
    tags$hr(),
    
    "This web application tracks trends in the permanent and contract data science job market",
    h2("Instructions"),
    "First select the number of topics from the Topic Modelling drop down, then explore the rest of the application!",
    h2("How does it work?"),
    "Each night we scrape the jobserve website using the search term 'Data Scientist'.",
    "We store the results and allow the user to interact with the data in a number of different ways.",
    tags$ul(
      tags$li("Inspect Data"), 
      tags$li("Topic Modelling"), 
      tags$li("Contract vs Perm"),
      tags$li("Time Series")
    ),
    h4("Inspect Data"),
    "We can explore all historical job postings using the filters at the top of the data.",
    "This is a useful feature since jobserve only stores the last 7 days worth of jobs",
    h4("Topic Modelling"),
    "We use a machine learning algorithm called Latent Dirichlet Allocation to uncover the underlying topics present in the job description.",
    "Each night we re-train the algorithm , meaning that the insights are as upto date as possible.",
    h4("Contract vs Perm"),
    "A comparison between Contract and Permanent employment using a number of metrics.",
    h4("Time Series"),
    "Time Series analysis showing the frequency of job posting over time split by job type."
    
  )
}