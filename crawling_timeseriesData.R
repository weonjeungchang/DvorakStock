
load("~/shiny/WJJang/DvorakStock/database/INV_MomentumItem.RData")
v_std_dt <- as.character(Sys.Date(), format = '%Y%m%d')
df_inxKOSPI <- tk_xts(df_inxKOSPI, date_var = 일자)
df_inxKOSPI$누적등락률 <- (cumprod(1+(df_inxKOSPI$등락률/100)) -1)

# ==============================================================================
# 수정주가
# ==============================================================================
from = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(6)) %>% str_remove_all('-') # 시작일
to = v_std_dt # 종료일

row.num <- nrow(INV_MomentumItem[INV_MomentumItem$시장구분 == '코스피',])

for(i in 1 : row.num ) {

  df_stockInfo = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  item_cd = INV_MomentumItem[INV_MomentumItem$시장구분 == '코스피',][i,]$종목코드
  item_cd = substr(item_cd, 4, 9)
  # item_cd = KOR_ticker$'종목코드'[i]     # 티커 부분 선택
  # item_nm = KOR_ticker$'종목명'[i]       # 티커 부분 선택

  # print(paste0("[", i, "/", nrow(KOR_ticker), "] ", i/nrow(KOR_ticker)*100, " %"))

  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0('https://fchart.stock.naver.com/siseJson.nhn?symbol=', item_cd,
                 '&requestType=1&startTime=', from, '&endTime=', to, '&timeframe=day')

    # 데이터 다운로드
    data = GET(url)
    data_html = data %>% read_html %>% html_text() %>% read_csv()

    # 필요한 열만 선택 후 클렌징
    df_stockInfo = data_html[c("[['날짜'", "'종가'", "'거래량'")]
    colnames(df_stockInfo) = (c('Date', 'Price', 'Volume'))
    df_stockInfo = na.omit(df_stockInfo)
    df_stockInfo$Date = parse_number(df_stockInfo$Date)
    df_stockInfo$Date = ymd(df_stockInfo$Date)
    df_stockInfo = tk_xts(df_stockInfo, date_var = Date)
    df_stockInfo$Return <- Return.calculate(df_stockInfo$Price)
    df_stockInfo$Return[is.na(df_stockInfo$Return)] <- 0.00
    df_stockInfo$CumulativeReturn <- cumprod(1 + df_stockInfo$Return) -1
    
  }, error = function(e) {

    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: (", item_cd, ")", item_nm))
  })

  ## save to RData
  save(df_stockInfo,
       file = paste0(getwd(), "/database/", item_cd, ".RData"))

  # 타임슬립 적용
  Sys.sleep(2)
}

## remove memory
rm(list=c('v_std_dt', 'data', 'data_html', 'df_stockInfo', 'url', 'i', 'from', 'to', 'item_cd', 'item_nm'))