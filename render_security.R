# ------------------------------------------------------------------------------
# reactive
# ------------------------------------------------------------------------------
ticker.filter <- reactive({
  df_render <- KOR_ticker
  if (input$market_dv != "ALL") {
    df_render <- df_render[df_render$시장구분 == input$market_dv,]
  }
  if (input$sector_dv != "ALL") {
    df_render <- df_render[df_render$업종명 == input$sector_dv,]
  }
  return(df_render)
})

## 상한가
output$tblUpperLimit <- DT::renderDataTable(
    DT::datatable({
      df_render <- STK_upperLimit
      if (input$market_dv != "ALL") {
        df_render <- df_render[df_render$시장구분 == input$market_dv,]
      }
      df_render[,c('종목코드','종목명','시장구분','종가','대비','등락률','시가','고가','저가','거래량','거래대금')]
    },
    # rownames=rownames(data.frame(R)),
    # colnames=colnames(data.frame(R)),
    selection = "none",
    options = list(scrollX = TRUE,
                   scrollY = TRUE,
                   paging = FALSE,
                   searching = FALSE),
    caption = paste0(as.POSIXct(v_std_dt, format = '%Y%m%d'), ' 기준')
    )
)

## 하한가
output$tblLoserLimit <- DT::renderDataTable(
  DT::datatable({
    df_render <- STK_lowerLimit
    if (input$market_dv != "ALL") {
      df_render <- df_render[df_render$시장구분 == input$market_dv,]
    }
    STK_lowerLimit[,c('종목코드','종목명','시장구분','종가','대비','등락률','시가','고가','저가','거래량','거래대금')]
  },
  # rownames=rownames(data.frame(R)),
  # colnames=colnames(data.frame(R)),
  selection = "none",
  options = list(scrollX = TRUE,
                 scrollY = TRUE,
                 paging = FALSE,
                 searching = FALSE),
  caption = paste0(as.POSIXct(v_std_dt, format = '%Y%m%d'), ' 기준')
  )
)

output$tblSecurity <- DT::renderDataTable(
  DT::datatable({
    ticker.filter()[, c('종목코드','종목명','종가','대비','등락률','시장구분','업종명','시가총액','EPS','PER','BPS','PBR','주당배당금','배당수익률')]
  },
  # rownames=rownames(data.frame(R)),
  # colnames=colnames(data.frame(R)),
  selection = "none",
  options = list(scrollX = TRUE,
                 scrollY = TRUE,
                 paging = TRUE,
                 searching = TRUE
                 # lengthMenu = c(25, 50, 100),
                 # pageLength = 20
                 ),
  caption = paste0(as.POSIXct(v_std_dt, format = '%Y%m%d'), ' 기준')
  )
)
