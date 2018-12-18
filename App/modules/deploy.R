deploy <- function(input, 
                   output, 
                   session,
                   Dno,
                   TName,
                   substation,
                   transformer,
                   Stage,
                   constants,
                   DT_HR,
                   T_W,
                   Modified_User,
                   Training_Start,
                   Training_End,
                   Heat_Run_DT_HR,
                   Heat_Run_T_W,
                   currentSession){
  
  #-----------------------------------------------------------------------
  #   0.  Validate Inputs
  
  T_O_   <- reactive({
    validate(
      need(!is.null(constants()$xbest[1]), "Please train the model first")
    )
    constants()$xbest[1]}
    )
  
  DT_OR_   <- reactive({
    validate(
      need(!is.null(constants()$xbest[2]), "Please train the model first")
    )
    constants()$xbest[2]}
  )
  
  R_   <- reactive({
    validate(
      need(!is.null(constants()$xbest[3]), "Please train the model first")
    )
    constants()$xbest[3]}
  )
  
  X_   <- reactive({
    validate(
      need(!is.null(constants()$xbest[4]), "Please train the model first")
    )
    constants()$xbest[4]}
  )
  
  Heat_Run_DT_HR_   <- reactive({
    validate(
      need(!is.null(Heat_Run_DT_HR()), "Please enter heat run data first")
    )
    Heat_Run_DT_HR()}
  )
  
  DT_HR_   <- reactive({
    validate(
      need(!is.null(DT_HR()), "Please enter heat run data (Top Oil Gradient) first"),
      need(DT_HR() != "", "Please enter heat run data (Top Oil Gradient) first"),
      need(DT_HR()>=1, "Something has gone wrong, heat run data (Top Oil Gradient) can't be less than 1"),
      need(DT_HR()<99, "Something has gone wrong, heat run data (Top Oil Gradient) shouldn't be that big")
    )
    DT_HR()}
  )

  Heat_Run_T_W_   <- reactive({
    validate(
      need(!is.null(Heat_Run_T_W()), "Please enter heat run data first")
    )
    Heat_Run_T_W()}
  )
  
  T_W_   <- reactive({
    validate(
      need(!is.null(T_W()), "Please enter heat run data (Winding Time Constant) first"),
      need(T_W() != "", "Please enter heat run data (Winding Time Constant) first"),
      need(T_W()>=1, "Something has gone wrong, heat run data (Winding Time Constant) can't be less than 1"),
      need(T_W()<20, "Something has gone wrong, heat run data (Winding Time Constant) shouldn't be that big")
    )
    T_W()}
  )
  
  #-----------------------------------------------------------------------
  #   2.  Pass data to UI
  
  # Thermal Constants
  thermalConstants <- reactive({
    
    data.frame("DNO" = Dno(),
               "Substation" = substation(),
               "Transformer" = transformer(),
               "Cooling Stage" = Stage(),
               "Tau_o" = T_O_(),
               "dT_or" = DT_OR_(),
               "R" = R_(),
               "x" = X_(),
               "Heat Run data available for dT_hr" = Heat_Run_DT_HR_(),
               "dT_hr" = DT_HR_(),
               "Heat Run data available for tao_w" = Heat_Run_T_W_(),
               "tao_w" = T_W_(),
               check.names = FALSE)
  })
  
  output$proposed <- renderTable({
    thermalConstants()
  })
  
  output$substation <- renderText({
    substation()
  })
  
  output$transformer <- renderText({
    transformer()
  })
  
  
  #-----------------------------------------------------------------------
  #   3.  Write to database
  
  # update existing record, setting flag to 'N' and specifying end_date
  # -- insert new record for thermal constants
  
  observeEvent(input$deployButton, {
    sql <- "IF EXISTS (SELECT 1 FROM [dbo].[THERMAL_CONSTANTS] 
                        WHERE TRANSFORMER_NAME_FK=?TName AND STAGE=?Stage AND INDICATOR='Y')
        
        		UPDATE [dbo].[THERMAL_CONSTANTS]
                SET   INDICATOR = 'N',
        		    END_DATE=?Update_Date
        		    WHERE TRANSFORMER_NAME_FK=?TName AND STAGE=?Stage AND INDICATOR='Y';
        		INSERT INTO [dbo].[THERMAL_CONSTANTS]
        		(TRANSFORMER_NAME_FK, STAGE, X, T_O, R, DT_OR, DT_HR, T_W, MODIFIED_USER, INDICATOR, START_DATE, END_DATE, TRAINING_START, TRAINING_END, HEAT_RUN_DT_HR, HEAT_RUN_T_W) 
        		VALUES
        		(?TName, ?Stage, ?X, ?T_O, ?R, ?DT_OR, ?DT_HR, ?T_W, ?Modified_User, 'Y', ?Update_Date, NULL, ?Training_Start, ?Training_End, ?Heat_Run_DT_HR, ?Heat_Run_T_W);"
    
    query <- sqlInterpolate(conn, 
                            sql, 
                            TName = TName(),
                            Stage = Stage(),
                            T_O = T_O_(),
                            DT_OR = DT_OR_(),
                            R = R_(),
                            X = X_(),
                            DT_HR = DT_HR_(),
                            T_W = T_W_(),
                            Modified_User = "Tony",
                            Update_Date = format(Sys.time(), format = "%Y%m%d %H:%M:%S"),
                            Training_Start = format(as.POSIXct(Training_Start()), "%Y-%m-%d"),
                            Training_End = format(as.POSIXct(Training_End()), "%Y-%m-%d"),
                            Heat_Run_DT_HR = Heat_Run_DT_HR_(),
                            Heat_Run_T_W = Heat_Run_T_W_()
    )  
    dbGetQuery(conn, query)
  })
  
  #-----------------------------------------------------------------------
  #   4.  Navigate to Active constants tab when deploy button click
  
  observeEvent(input$deployButton, {
    updateNavbarPage(currentSession, "nav-page", "Home")
  })
  
  #-----------------------------------------------------------------------
  #   1.  Render UI
  
  output$deployToDatabase <- renderUI({
    
    ns <- session$ns
    
    if (is.null(T_W_())|T_W_()==""|is.null(DT_HR_())|DT_HR_()==""|is.null(T_O_())|T_O_()==""|is.null(constants())){
      tagList(
        tabPanel(title = "Deploy", 
                 tableOutpt(ns("proposed")))
      )
    } else {
      
      tagList(
        tabPanel(title = "Deploy",
                 h3("You are about to deploy the following thermal constants"),
                 tableOutput(ns("proposed")),
                 actionButton(ns("deployButton"), "Deploy"),
                 p("Click to deploy the thermal constants")
        )
      )
    }
  })
  
  #-----------------------------------------------------------------------
  #   5.  Return deploy button click
  
  return(deployClick <- reactive({input$deployButton}))
  

  
  
}

