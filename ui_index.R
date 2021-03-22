tabPanel("Index",
         tags$head(
           tags$style(HTML("table {
                              font-size:13px;
                            }"))
         ),
         sidebarPanel(
           style = "position:fixed; margin-top:80px; width:400px",
           prettyRadioButtons(inputId = "charLineDv",
                              label = "Char Line",
                              choices = list("종가"="종가",
                                             "수익률"="수익률",
                                             "누적수익률"="누적수익률"),
                              selected = '누적수익률')
         ),
         mainPanel(
           style = "margin-left:450px; margin-top:80px",
           highchartOutput("LineChart_index", height = "550px"),
           hr(),
           highchartOutput("LineChart_gold", height = "350px")
         )
)
