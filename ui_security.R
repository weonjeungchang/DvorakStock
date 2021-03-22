tabPanel("Security(Stock)",
         sidebarPanel(
         style = "position:fixed; margin-top:80px; width:400px",
         prettyRadioButtons(inputId = "market_dv",
                            label = "시장구분",
                            choices = c('ALL', unique(KOR_ticker$시장구분)),
                            selected = 'ALL'),
         selectInput(inputId = "sector_dv",
                     label = "섹터(업종)",
                     choices = c('ALL', sort(unique(KOR_ticker$업종명))),
                     selected = 'ALL',
                     multiple = TRUE,
                     selectize = FALSE,
                     size = 25)
         ),
         mainPanel(
           style = "margin-left:450px; margin-top:80px",
           HTML('<font color=red><b><big> ▶ 상한가 </big></b>'),
           DT::dataTableOutput("tblUpperLimit"),
           HTML('</font>'),
           hr(),
           HTML('<font color=blue><b><big> ▶ 하한가 </big></b>'),
           DT::dataTableOutput("tblLoserLimit"),
           HTML('</font>'),
           hr(),
           DT::dataTableOutput("tblSecurity")
         )
)
