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
                      tabPanel("Top Words",
                               topicWordsUI("id2c")),
                      tabPanel("Probabilities",
                               topicProbUI("id2d"))),
           #-----------------------------------------------------------------------
           #   3.  Contract vs Perm

           navbarMenu(title = "Contract vs Perm",
                      tabPanel("Overall",
                               overallUI("id3a")),
                      tabPanel("Pay",
                               payUI("id3b")),
                      tabPanel("Roles",
                               rolesUI("id3c"))),
           
           #-----------------------------------------------------------------------
           #   4.  Location
           
           tabPanel(title = "Location",
                    locationSplitUI("id4a")),
           
           #tabPanel(title = "Location",
           #         locationSplitUI("id4a")),

           #-----------------------------------------------------------------------
           #   5.  Trends

           navbarMenu(title = "Trends",
                      tabPanel("Overall",
                               timeSeriesOverallUI("id5a")),
                      tabPanel("Job Type",
                               timeSeriesJobUI("id5b")),
                      tabPanel("Tools",
                               timeSeriesToolsUI("id5c")))
)  


