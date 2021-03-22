
#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()

options("scipen" = 100)

v_std_dt = format(Sys.Date() -0, '%Y%m%d')
v_pre_dt = format(Sys.Date() -1, '%Y%m%d')

v_from_dt = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(6)) %>% str_remove_all('-') # 시작일
v_to_dt   = v_std_dt # 종료일

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
# "종목코드""종목명""시장구분""업종명""종가""대비""등락률""시가총액"
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
# "종목코드""종목명""시장구분""업종명""종가""대비""등락률""시가총액"
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

## rbind
down_sector <- rbind(down_sector_KS, down_sector_KQ)
rm(list=c('down_sector_KS', 'down_sector_KQ'))

# ==============================================================================
# 개별종목 지표
# "종목코드""종목명""종가""대비""등락률""EPS""PER""BPS""PBR""주당배당금""배당수익률"
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

# ==============================================================================
# ticker merge
# "종목코드""종목명""종가""대비""등락률""시장구분""업종명""시가총액""EPS""PER""BPS""PBR""주당배당금""배당수익률"
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
     file = paste0(getwd(), "/database/KOR_ticker.RData"))

## remove memory
rm(list=c('KOR_ticker', 'down_sector', 'down_ind'))

# ==============================================================================
# 상한가
# ==============================================================================
gen_otp_data = list(
  mktId = 'ALL',
  flucTpCd = '4',
  trdDd = '20210311',
  share = '1',
  money = '1',
  csvxls_isNo = 'true',
  name = 'fileDown',
  url = 'dbms/MDC/EASY/ranking/MDCEASY01801')

otp = POST(gen_otp_url, query = gen_otp_data) %>% read_html() %>% html_text()

STK_upperLimit = POST(down_url, query = list(code = otp),
                       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

## 번호제거
STK_upperLimit <- STK_upperLimit[, -c(1)]
## 기준일 조립
STK_upperLimit$STD_DT <- v_std_dt
## 시장구분별 정렬
STK_upperLimit <- STK_upperLimit[with(STK_upperLimit, order(desc(시장구분))), ]

## save to RData
save(STK_upperLimit,
     file = paste0(getwd(), "/database/STK_upperLimit.RData"))

## remove memory
rm(list=c('STK_upperLimit'))

# ==============================================================================
# 하한가
# ==============================================================================
gen_otp_data = list(
  mktId = 'ALL',
  flucTpCd = '5',
  trdDd = '20210311',
  share = '1',
  money = '1',
  csvxls_isNo = 'true',
  name = 'fileDown',
  url = 'dbms/MDC/EASY/ranking/MDCEASY01801')

otp = POST(gen_otp_url, query = gen_otp_data) %>% read_html() %>% html_text()

STK_lowerLimit = POST(down_url, query = list(code = otp),
                       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

## 번호제거
STK_lowerLimit <- STK_lowerLimit[, -c(1)]
## 기준일 조립
STK_lowerLimit$STD_DT <- v_std_dt
## 시장구분별 정렬
STK_lowerLimit <- STK_lowerLimit[with(STK_lowerLimit, order(desc(시장구분))), ]

## save to RData
save(STK_lowerLimit,
     file = paste0(getwd(), "/database/STK_lowerLimit.RData"))

## remove memory
rm(list=c('STK_lowerLimit'))


#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()


