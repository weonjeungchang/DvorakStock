# "종목코드", "종목명",
# "종가", "대비", "등락률", "시장구분", "업종명", "시가총액",
# "EPS", "PER", "BPS", "PBR", "주당배당금", "배당수익률",
# "STD_DT", "TIME"


## 메모리 청소
rm(list = ls())
gc()

options("scipen" = 100)

# ==============================================================================
# package (sapply)
# ==============================================================================
# install.packages("timetk", lib="/usr/lib64/R/library")
pkg = c('httr', 'rvest', 'readr', 'stringr', 'lubridate', 'readr', 'timetk')
sapply(pkg, require, character.only = TRUE)
rm(pkg)

if(format(Sys.time() -1, '%H%M%S') < '160000') {
  v_std_dt = format(Sys.Date() -1, '%Y%m%d')
} else {
  v_std_dt = format(Sys.Date() -0, '%Y%m%d')
}

# ## -2 영업일
# url = 'https://finance.naver.com/sise/sise_deposit.nhn'
# biz_day = GET(url) %>%
#   read_html(encoding = 'EUC-KR') %>%
#   html_nodes(xpath =
#                '//*[@id="type_1"]/div/ul[2]/li/span') %>%
#   html_text() %>%
#   str_match(('[0-9]+.[0-9]+.[0-9]+') ) %>%
#   str_replace_all('\\.', '')
# rm(url)

### generate.cmd
gen_otp_url = 'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
### download.cmd
down_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'

# ==============================================================================
# KOSPI kicker
# ==============================================================================
gen_otp_data = list(
  mktId       = 'STK',  # STK:코스피, KSQ:코스닥
  trdDd       = v_std_dt,
  money       = '1',
  csvxls_isNo = 'false',
  name        = 'fileDown',
  url         = 'dbms/MDC/STAT/standard/MDCSTAT03901')

otp = POST(gen_otp_url, query = gen_otp_data) %>% read_html() %>% html_text()

down_sector_KS = POST(down_url, query = list(code = otp),
                      add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

# ==============================================================================
# KODAQ kicker
# ==============================================================================
gen_otp_data = list(
  mktId       = 'KSQ',  # STK:코스피, KSQ:코스닥
  trdDd       = v_std_dt,
  money       = '1',
  csvxls_isNo = 'false',
  name        = 'fileDown',
  url         = 'dbms/MDC/STAT/standard/MDCSTAT03901')

otp = POST(gen_otp_url, query = gen_otp_data) %>% read_html() %>% html_text()

down_sector_KQ = POST(down_url, query = list(code = otp),
                      add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

## save to RData
down_sector <- rbind(down_sector_KS, down_sector_KQ)
rm(list=c('down_sector_KS', 'down_sector_KQ'))
# save(down_sector,
#      file = paste0("/home/WJJang/shiny/WJJang/DvorakStock/database/sector_", v_std_dt, ".RData"))

# ==============================================================================
# 개별종목 지표
# ==============================================================================
gen_otp_data = list(
  searchType  = '1',
  mktId       = 'ALL',
  trdDd       = v_std_dt,
  csvxls_isNo = 'false',
  name        = 'fileDown',
  url         = 'dbms/MDC/STAT/standard/MDCSTAT03501')

otp = POST(gen_otp_url, query = gen_otp_data) %>% read_html() %>% html_text()

down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

# ## save to RData
# save(down_ind,
#      file = paste0("/home/WJJang/shiny/WJJang/DvorakStock/database/indicator_", v_std_dt, ".RData"))

## remove memory
rm(list=c('gen_otp_data', 'down_url', 'gen_otp_url', 'otp'))

# ==============================================================================
# ticker merge
# ==============================================================================
KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector), names(down_ind)),
                   all = FALSE)  # TRUE:합집합, FALSE:교집합

## 스팩 제거
KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']), ]  
## 우선주 제거
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) == 0, ]
## 기준일 조립
KOR_ticker$STD_DT <- v_std_dt
## 기준시간 조립
KOR_ticker$TIME <- Sys.time()

## save to RData
save(KOR_ticker,
     file = paste0(getwd(), "/database/KOR_ticker_", format(Sys.Date(), '%Y%m%d'), ".RData"))

## remove memory
rm(list=c('down_sector', 'down_ind'))

# ==============================================================================
# 수정주가
# ==============================================================================
from = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(3)) %>% str_remove_all('-') # 시작일
to = v_std_dt # 종료일

for(i in 1 : nrow(KOR_ticker) ) {
  
  price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
  item_cd = KOR_ticker$'종목코드'[i]     # 티커 부분 선택
  item_nm = KOR_ticker$'종목명'[i]       # 티커 부분 선택
  
  print(paste0("[", i, "/", nrow(KOR_ticker), "] ", i/nrow(KOR_ticker)*100, " %"))
  
  # 오류 발생 시 이를 무시하고 다음 루프로 진행
  tryCatch({
    # url 생성
    url = paste0('https://fchart.stock.naver.com/siseJson.nhn?symbol=', item_cd,
                 '&requestType=1&startTime=', from, '&endTime=', to, '&timeframe=day')
    
    # 데이터 다운로드
    data = GET(url)
    data_html = data %>% read_html %>% html_text() %>% read_csv()
    
    # 필요한 열만 선택 후 클렌징
    price = data_html[c(1, 5, 6)]
    colnames(price) = (c('Date', 'Price', 'Volume'))
    price = na.omit(price)
    price$Date = parse_number(price$Date)
    price$Date = ymd(price$Date)
    price = tk_xts(price, date_var = Date)
    
  }, error = function(e) {
    
    # 오류 발생시 해당 종목명을 출력하고 다음 루프로 이동
    warning(paste0("Error in Ticker: (", item_cd, ")", item_nm))
  })

  ## save to RData
  save(price,
       file = paste0(getwd(), "/DvorakStock/database/", item_cd, "_price_", to, "_", from, ".RData"))
  
  # 타임슬립 적용
  Sys.sleep(2)
}

## remove memory
rm(list=c('v_std_dt', 'data', 'data_html', 'price', 'url', 'i', 'from', 'to', 'item_cd', 'item_nm'))


















# unique(KOR_ticker[,c('시장구분')])
# unique(KOR_ticker[order(KOR_ticker['업종명']), ][,c('업종명')])



