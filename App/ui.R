navbarPage(id = "nav-page",
           title = "RTTR Training",
           
           #-----------------------------------------------------------------------
           #   1.  Home
           
           tabPanel(title = "Home",
                    homeUI()),
           
           #-----------------------------------------------------------------------
           #   2.  Load Data
           
           tabPanel(title = "Load Data",
                    loadDataUI("id1")),
           
           #-----------------------------------------------------------------------
           #   3.  LDA vis
           
           navbarMenu(title = "Topic Modelling",
                      tabPanel("Visualisation",
                               topicVizUI("id2a")),
                      tabPanel("Probabilities",
                               topicProbUI("id2b")),
                      tabPanel("Top Words",
                               topicWordsUI("id2c")),
                      tabPanel("Number of Topics",
                               topicNumUI("id2d",
                                          choices = optimalSettings$k %>% as.character(), 
                                          selected = optimalK))),
           
           #-----------------------------------------------------------------------
           #   4.  Contract vs Perm
           
           navbarMenu(title = "Contract vs Perm",
                      tabPanel("Tools",
                               toolsUI("id4a")),
                      tabPanel("Topics",
                               topicsUI("id4b")),
                      tabPanel("Pay",
                               payUI("id4c")),
                      tabPanel("Roles",
                               rolesUI("id4d"))),
           
           
           #-----------------------------------------------------------------------
           #   5.  Tools
           
           tabPanel(title = "Time Series",
                    timeSeriesUI("id5"))
           
           
)  


