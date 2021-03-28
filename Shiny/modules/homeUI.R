homeUI <- function(id){
  ns <- shiny::NS(id)
  
  tagList(
    h1("Trends in Data Science"),
    img(src = "datascience.png", width = 500, height = 400),
    tags$hr(),
    h2("About"),
    "This web application tracks trends in the permanent and contract data science job market.",
    "Every weekday we perform the following:",
    tags$ol(
      tags$li("Scrape all 'Data Scientist' jobs from jobserve.co.uk"),
      tags$li("Pre-process data, produce visualisations and build topic models on the job description"),
      tags$li("Present output using this interactive Shiny application")
    ),
    textOutput(ns("job_count")),
    tags$hr(),
    h2("Navigating the App"),
    h4("Data"),
    "Select between Permanent and Contract roles then explore historical job postings.",
    "Use the filters at the top to perform keyword search, or use arrows to sort data by salary or posted date.",
    h4("Topic Modelling"),
    tags$ol(
      tags$li("Select Number of Topics"),
      tags$li("Visualisation: Explore each topic interactively using LDAVis"),
      tags$li("Top Words: Understand all topics at a glance"),
      tags$li("Probabilities: Filter using ID to understand a given job descriptions (posterior) topic probabilities, or filter using Topic and Probability to bring back examples of certain topics")
    ),
    h4("Contract vs Perm"),
    "A comparison between Contract and Permanent employment.",
    h4("Location"),
    "A comparison between London and the rest of the UK.",
    h4("Trends"),
    "Monitor the monthly trends for both job type (Perm/Contract) and tools (Python/R).",
    tags$hr(),
    h2("Source Code"),
    "Full source code available on ",
    tags$a(href="https://github.com/tonyjward/trends-in-data-science", "github"),
    tags$hr(),
    h2("Write-up"),
    "Medium article: ",
    tags$a(href="https://medium.com/p/python-vs-r-what-i-learned-from-4-000-job-advertisements-ab41661b7f28?source=email-b557f284be98--writer.postDistributed&sk=47772a3ea916263ada1e461f2088422e", 
           "Python vs R: How to Analyse 4000 Job Advertisements Using Shiny and Machine Learning"),
    tags$hr(),
    h2("App Author"),
    "Tony Ward -  ",
    tags$a(href="https://statcore.co.uk/", "Data Science Consultant")
    
  )
}
