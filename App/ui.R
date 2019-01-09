navbarPage(id = "nav-page",
           title = "RTTR Training",
           
           #-----------------------------------------------------------------------
           #   1.  Home
           
           tabPanel(title = "Home",
                    homeUI()),
           
           #-----------------------------------------------------------------------
           #   1.  Inspect Data
           
           tabPanel(title = "Inspect Data",
                    inspectDataUI("id1")),
           
           #-----------------------------------------------------------------------
           #   2.  topic Modelling
           
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
                      tabPanel("Tools",
                               toolsUI("id3a")),
                      tabPanel("Topics",
                               topicsUI("id3b")),
                      tabPanel("Pay",
                               payUI("id3c")),
                      tabPanel("Roles",
                               rolesUI("id3d"))),
           
           #-----------------------------------------------------------------------
           #   4.  Time Series
           
           tabPanel(title = "Time Series",
                    timeSeriesUI("id4"))
)  


