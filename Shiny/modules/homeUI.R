homeUI <- function(){
  tagList(
    h1("Trends in Data Science"),
    "This web application tracks trends in the permanent and contract data science job market.",
    tags$br(),
    tags$br(),
    img(src = "datascience.png", width = 500, height = 400),
    tags$hr(),
    h2("Instructions & Source Code"),
    "Instructions on how to use the app can be found at this",
    tags$a(href="https://github.com/tonyjward/trends-in-data-science", "medium article"),
    tags$br(),
    "Full source code available at this ",
    tags$a(href="https://github.com/tonyjward/trends-in-data-science", "github repo"),
    tags$br(),
    "If you find this app useful please give some stars/claps :)",
    tags$hr(),
    h2("Project Description"),
    "The data source for this project is jobserve.co.uk. On a schedule (daily) we perform the following",
    tags$ol(
      tags$li("Scrape all 'Data Scientist' jobs from jobserve"),
      tags$li("Pre-process data, produce visualisations and build topic models on the job description"),
      tags$li("Present output using an interactive web application")
    ),
    tags$hr(),
    h2("App Navigation"),
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
    "Monitor the monthly trends for both job type (Perm/Contract) and tools (Python/R)."
    
  )
}