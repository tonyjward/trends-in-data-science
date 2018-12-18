constantsHistory <- function(input, output, session, deployClick){
  
  #-----------------------------------------------------------------------
  #   1.  Load All Data
  
  dt <- reactive({
    
    # Ensure table refreshes each time someone deploys a new set of thermal constants
    deployClick()
    
    sql <- "SELECT B.DNO, B.SUBSTATION_NAME, B.Transformer_DisplayName
              ,[STAGE]
              ,[INDICATOR] AS ACTIVE
              ,[START_DATE]
              ,[END_DATE]
              ,[X]
              ,[T_O]
              ,[R]
              ,[DT_OR]
              ,[HEAT_RUN_DT_HR]
              ,[DT_HR]
              ,[HEAT_RUN_T_W]
              ,[T_W]
              ,[MODIFIED_USER]
              ,[TRAINING_START]
              ,[TRAINING_END]
            FROM [RTTR_Dev].[dbo].[THERMAL_CONSTANTS] A
            INNER JOIN [RTTR_Dev].[dbo].[TRANSFORMERS_MASTER] B
            ON A.TRANSFORMER_NAME_FK = B.TRANSFORMER_NAME 
            ORDER BY B.DNO, B.SUBSTATION_NAME, B.Transformer_DisplayName, START_DATE DESC;"
    
    query <- sqlInterpolate(conn, sql) # prevents sql injection attacks
    
    dt <- dbGetQuery(conn, query) %>% as.data.table()
    
    # convert time to date format
    dt[,START_DATE := as.POSIXct(START_DATE, format="%Y-%m-%d %H:%M:%S")]
    dt[,TRAINING_START := as.POSIXct(TRAINING_START, format="%Y-%m-%d %H:%M:%S")]
    dt[,TRAINING_END := as.POSIXct(TRAINING_END, format="%Y-%m-%d %H:%M:%S")]
    
    setnames(dt,
             old = c("SUBSTATION_NAME", 
                     "Transformer_DisplayName", 
                     "START_DATE",
                     "END_DATE",
                     "TRAINING_START", 
                     "TRAINING_END", 
                     "HEAT_RUN_DT_HR", 
                     "HEAT_RUN_T_W", 
                     "MODIFIED_USER",
                     "STAGE"),
             new = c("Substation", 
                     "Transformer",  
                     "Deployment Date Start",
                     "Deployment Date End",
                     "Training Data Start", 
                     "Training Data End", 
                     'Heat Dun data available for DT_HR', 
                     'Heat Run data available for Tao_w', 
                     'Modified User',
                     "Cooling Stage"))

    dt
  }) 
  
  output$tbl <- DT::renderDataTable({
    datatable(dt(),
              rownames = FALSE) %>% 
      formatRound(c("X", "T_O", "R", "DT_OR", "DT_HR", "T_W"), 2) %>%
      formatDate(c("Deployment Date Start",
                   "Deployment Date End"), method = "toUTCString", params = NULL) %>%
      formatDate(c("Training Data Start", 
                   "Training Data End" ), method = "toDateString", params = NULL)
  }) 
  
}