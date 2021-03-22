output$LineChart_index <- renderHighchart({
  highchart() %>%
    hc_title(text= "INDEXES") %>%
    hc_subtitle(text= "source: KRX's InformatinDataSystem") %>%
    # hc_xAxis(categories = as.list(index(df_inxKOSPI))) %>%
    hc_yAxis(title = list(text = "Returns"),
             showLastLabel = TRUE) %>%
    hc_add_series(
      data = df_inxKOSPI$누적등락률,
      type = "line",
      name = "KOSPI"
    ) %>%
    hc_add_series(
      data = df_inxKOSDAQ$누적등락률,
      type = "line",
      name = "KOSDAQ"
    ) %>%
    hc_add_series(
      data = df_inxKOSPI200$누적등락률,
      type = "line",
      name = "KOSPI 200"
    ) %>%
    hc_add_series(
      data = df_inxKOSDAQ150$누적등락률,
      type = "line",
      name = "KOSDAQ 150"
    ) %>%
    hc_add_series(
      data = df_inxAmeDolFur$누적등락률,
      type = "line",
      name = "미국달러선물지수"
    ) %>%
    hc_add_series(
      data = df_inxKRXGold$누적등락률,
      type = "line",
      name = "KRX 금현물지수"
    )
})

output$LineChart_gold <- renderHighchart({
  highchart() %>%
    hc_title(text= "GOLD") %>%
    # hc_subtitle(text= "(portfolio returns) - (benchmark returns)") %>%
    # hc_xAxis(categories = as.character(index(df_inxGold99))) %>%
    hc_yAxis(title = list(text = "Returns")) %>%
  hc_add_series(
    data = df_inxGold99$누적등락률,
    type = "line",
    name = "금 99.99K"
  ) %>%
  hc_add_series(
    data = df_inxMiniGold$누적등락률,
    type = "line",
    name = "미니금 100g"
  )
})