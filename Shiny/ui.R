navbarPage(id = "nav-page",
           title = "Data Science",
           
           #-----------------------------------------------------------------------
           #   Tab 1.  Home
           
           tabPanel(title = "Home",
                    homeUI()),
           
           #-----------------------------------------------------------------------
           #   Tab 2.  Data
           
           tabPanel(title = "Data",
                    inspectDataUI("id1")),
           
           #-----------------------------------------------------------------------
           #   Tab 3.  Topic Modelling

           navbarMenu(title = "Topic Modelling",
                      tabPanel("Select Number of Topics",
                               topicNumUI("id2a",
                                          choices = optimalSettings$k %>% as.character(),
                                          selected = optimalK)),
                      tabPanel("Visualisation",
                               topicVizUI("id2b")),
                      tabPanel("Probabilities",
                               topicProbUI("id2c")),
                      tabPanel("Top Words",
                               topicWordsUI("id2d"))),

           #-----------------------------------------------------------------------
           #   3.  Contract vs Perm

           navbarMenu(title = "Contract vs Perm",
                      tabPanel("Overall",
                               toolsUI("id3a")),
                      tabPanel("Pay",
                               payUI("id3b")),
                      tabPanel("Roles",
                               rolesUI("id3c"))),

           #-----------------------------------------------------------------------
           #   4.  Time Series

           navbarMenu(title = "Trends",
                      tabPanel("Overall",
                               timeSeriesOverallUI("id4a")),
                      tabPanel("Job Type",
                               timeSeriesJobUI("id4b")),
                      tabPanel("Tools",
                               timeSeriesToolsUI("id4c")))
)  


