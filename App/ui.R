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
           
           tabPanel(title = "LDA vis",
                    topicVisUI("id2"))
           
           # tabPanel(title = "Reports",
           #          dateRangeInput("daterangeReports", "Date range: Reports"),
           #          reportsUI("Top Oil", choices = plotVars, selected = plotVars[1]),
           #          reportsUI("Load", choices = plotVars, selected = plotVars[3])
           # ),
           # 
           # #-----------------------------------------------------------------------
           # #   4.  Test
           # 
           # # tabPanel(title = "Test",
           # #          verbatimTextOutput("summary1")),
           # 
           # #-----------------------------------------------------------------------
           # #   5.  Training
           # 
           # tabPanel(title = "Training",
           #          trainingUI("id5")),
           # 
           # #-----------------------------------------------------------------------
           # #   6.  Validation
           # 
           # tabPanel(title = "Validation",
           #          validationUI("id6")),
           # 
           # #-----------------------------------------------------------------------
           # #   7.  Heat Run Data
           # 
           # tabPanel(title = "Heat Run Data",
           #          heatRunUI("id7")),
           # 
           # #-----------------------------------------------------------------------
           # #   8.  Deploy
           # 
           # tabPanel(title = "Deploy",
           #          deployUI("id8")),
           # 
           # #-----------------------------------------------------------------------
           # #   9.  Constants
           # 
           # navbarMenu(title = "Constants",
           #            tabPanel("Active",
           #                     constantsActiveUI("id9a")),
           #            tabPanel("History",
           #                     constantsHistoryUI("id9b"))),
           # 
           # #-----------------------------------------------------------------------
           # #   10.  Monitor
           # tabPanel(title = "Monitor",
           #          monitorUI("id10"))
           # 
)  


