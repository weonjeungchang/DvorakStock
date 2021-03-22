output$moentumColumnChart <- renderHighchart({
  df_render <- INV_MomentumItem
  if (input$ss_market_dv != "ALL") {
    df_render <- df_render[df_render$시장구분 == input$ss_market_dv,]
  }
  highchart() %>% 
    hc_title(text= "Momentum") %>%
    hc_subtitle(text= "Momentum by 6months") %>%
    hc_add_series(df_render,
                  type = "column",
                  showInLegend = FALSE,
                  hcaes(x = 종목명, y = as.numeric(모멘텀_6개월))) %>% 
    hc_xAxis(categories = df_render$종목명)
})


output$tblMoentum <- DT::renderDataTable(
  DT::datatable({
    df_render <- INV_MomentumItem
    if (input$ss_market_dv != "ALL") {
      df_render <- df_render[df_render$시장구분 == input$ss_market_dv,]
    }
    df_render[,c("시장구분", "종목코드", "종목명", "모멘텀_6개월", "모멘텀_12개월", "모멘텀_과거",
                 "현재가", "시가", "고가", "저가", "대비", "등락률", "시가총액")]
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

output$tblreveralShortTerm <- DT::renderDataTable(
  DT::datatable({
    df_render <- INV_reversalShortTerm
    if (input$ss_market_dv != "ALL") {
      df_render <- df_render[df_render$시장구분 == input$ss_market_dv,]
    }
    df_render[,c("시장구분", "종목코드", "종목명", "단기반전_과거수익률", "단기반전_직전수익률", "단기반전_반전여부",
                 "현재가", "시가", "고가", "저가", "대비", "등락률", "시가총액")]
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

output$tblreveralLongTerm <- DT::renderDataTable(
  DT::datatable({
    df_render <- INV_reversalLongTerm
    if (input$ss_market_dv != "ALL") {
      df_render <- df_render[df_render$시장구분 == input$ss_market_dv,]
    }
    df_render[,c("시장구분", "종목코드", "종목명", "장기반전_과거수익률", "장기반전_직전수익률", "장기반전_반전여부" ,
                 "현재가", "시가", "고가", "저가", "대비", "등락률", "시가총액")]
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