tabPanel("Selection Strategy",
         sidebarPanel(
           style = "position:fixed; margin-top:80px; width:400px",
           prettyRadioButtons(inputId = "ss_market_dv",
                              label = "시장구분",
                              choices = list('ALL'='ALL', 'KOSPI'='코스피', 'KOSDAQ'='코스닥'),
                              selected = 'ALL')
         ),
         mainPanel(
           style = "margin-left:450px; margin-top:80px",
           tabsetPanel(
             type = "tabs",
             tabPanel("모멘텀",
                      br(),
                      highchartOutput("moentumColumnChart", height = "400px"),
                      DT::dataTableOutput("tblMoentum")
             ),
             tabPanel("Golden Cross",
                      DT::dataTableOutput("tblGoldenCross")
             ),
             tabPanel("단기반전",
                      DT::dataTableOutput("tblreveralShortTerm")
             ),
             tabPanel("장기반전",
                      DT::dataTableOutput("tblreveralLongTerm")
             )
           )
         )
)
