output$LineChart_index <- renderHighchart({
  highchart() %>%
    hc_title(text= "INDEXES") %>%
    # hc_subtitle(text= "(portfolio returns) - (benchmark returns)") %>%
    hc_xAxis(categories = df_inxKOSPI[with(df_inxKOSPI, order(일자)), ]$일자) %>%
    # hc_yAxis(title = list(text = "Returns")) %>%
    hc_add_series(
      data = df_inxKOSPI[-order('일자')]$종가,
      type = "line",
      name = "KOSPI"
    ) %>%
    hc_add_series(
      data = df_inxKOSDAQ[-order('일자')]$종가,
      type = "line",
      name = "KOSDAQ"
    ) %>%
    hc_add_series(
      data = df_inxKOSPI200[-order('일자')]$종가,
      type = "line",
      name = "KOSPI 200"
    ) %>%
    hc_add_series(
      data = df_inxKOSDAQ150[-order('일자')]$종가,
      type = "line",
      name = "KOSDAQ 150"
    ) %>%
    hc_add_series(
      data = df_inxAmeDolFur[-order('일자')]$종가,
      type = "line",
      name = "미국달러선물지수"
    ) %>%
    hc_add_series(
      data = df_inxKRXGold[-order('일자')]$종가,
      type = "line",
      name = "KRX 금현물지수"
    )
})
