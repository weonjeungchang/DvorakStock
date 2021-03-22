
#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()

options("scipen" = 100)

v_std_dt = format(Sys.Date() -0, '%Y%m%d')
v_pre_dt = format(Sys.Date() -1, '%Y%m%d')

v_from_dt = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(6)) %>% str_remove_all('-') # 시작일
v_to_dt   = v_std_dt # 종료일

gen_otp_url  = 'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
download_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'

# ==============================================================================
# 코스피
# ==============================================================================
gen_otp_data = list(
  tboxindIdx_finder_equidx0_3   = '코스피',
  indIdx                        = '1',
  indIdx2                       = '001',
  codeNmindIdx_finder_equidx0_3 = '코스피',
  param1indIdx_finder_equidx0_3 = '',
  strtDd                        = v_from_dt,
  endDd                         = v_to_dt,
  share                         = '1',
  money                         = '1',
  csvxls_isNo                   = 'false',
  name                          = 'fileDown',
  url                           = 'dbms/MDC/STAT/standard/MDCSTAT00301')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxKOSPI =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxKOSPI <- tk_xts(df_inxKOSPI, date_var = 일자)
df_inxKOSPI$누적등락률 <- (cumprod(1+(df_inxKOSPI$등락률/100)) -1)

# ==============================================================================
# 코스피 200
# ==============================================================================
gen_otp_data = list(
  tboxindIdx_finder_equidx0_3   = '코스피 200',
  indIdx                        = '1',
  indIdx2                       = '028',
  codeNmindIdx_finder_equidx0_3 = '코스피 200',
  param1indIdx_finder_equidx0_3 = '',
  strtDd                        = v_from_dt,
  endDd                         = v_to_dt,
  share                         = '1',
  money                         = '1',
  csvxls_isNo                   = 'false',
  name                          = 'fileDown',
  url                           = 'dbms/MDC/STAT/standard/MDCSTAT00301')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxKOSPI200 =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxKOSPI200 <- tk_xts(df_inxKOSPI200, date_var = 일자)
df_inxKOSPI200$누적등락률 <- (cumprod(1+(df_inxKOSPI200$등락률/100)) -1)

# ==============================================================================
# 코스닥
# ==============================================================================
gen_otp_data = list(
  tboxindIdx_finder_equidx0_3   = '코스닥',
  indIdx                        = '2',
  indIdx2                       = '001',
  codeNmindIdx_finder_equidx0_3 = '코스닥',
  param1indIdx_finder_equidx0_3 = '',
  strtDd                        = v_from_dt,
  endDd                         = v_to_dt,
  share                         = '1',
  money                         = '1',
  csvxls_isNo                   = 'false',
  name                          = 'fileDown',
  url                           = 'dbms/MDC/STAT/standard/MDCSTAT00301')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxKOSDAQ =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxKOSDAQ <- tk_xts(df_inxKOSDAQ, date_var = 일자)
df_inxKOSDAQ$누적등락률 <- (cumprod(1+(df_inxKOSDAQ$등락률/100)) -1)

# ==============================================================================
# 코스닥 150
# ==============================================================================
gen_otp_data = list(
  tboxindIdx_finder_equidx0_3   = '코스닥 150',
  indIdx                        = '2',
  indIdx2                       = '203',
  codeNmindIdx_finder_equidx0_3 = '코스닥 150',
  param1indIdx_finder_equidx0_3 = '',
  strtDd                        = v_from_dt,
  endDd                         = v_to_dt,
  share                         = '1',
  money                         = '1',
  csvxls_isNo                   = 'false',
  name                          = 'fileDown',
  url                           = 'dbms/MDC/STAT/standard/MDCSTAT00301')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxKOSDAQ150 =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxKOSDAQ150 <- tk_xts(df_inxKOSDAQ150, date_var = 일자)
df_inxKOSDAQ150$누적등락률 <- (cumprod(1+(df_inxKOSDAQ150$등락률/100)) -1)

# ==============================================================================
# 미국달러선물지수
# ==============================================================================
gen_otp_data = list(
  indTpCd                         = 'S',
  idxIndCd                        = '001',
  tboxidxCd_finder_drvetcidx0_7   = '미국달러선물지수',
  idxCd                           = 'S',
  idxCd2                          = '001',
  codeNmidxCd_finder_drvetcidx0_7 = '미국달러선물지수',
  param1idxCd_finder_drvetcidx0_7 = '',
  strtDd                          = v_from_dt,
  endDd                           = v_to_dt,
  csvxls_isNo                     = 'false',
  name                            = 'fileDown',
  url                             = 'dbms/MDC/STAT/standard/MDCSTAT01201')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxAmeDolFur =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxAmeDolFur <- tk_xts(df_inxAmeDolFur, date_var = 일자)
df_inxAmeDolFur$누적등락률 <- (cumprod(1+(df_inxAmeDolFur$등락률/100)) -1)

# ==============================================================================
# KRX 금현물지수
# ==============================================================================
gen_otp_data = list(
  indTpCd                         = 'P',
  idxIndCd                        = '002',
  tboxidxCd_finder_drvetcidx0_7   = 'KRX 금현물지수',
  idxCd                           = 'P',
  idxCd2                          = '001',
  codeNmidxCd_finder_drvetcidx0_7 = 'KRX 금현물지수',
  param1idxCd_finder_drvetcidx0_7 = '',
  strtDd                          = v_from_dt,
  endDd                           = v_to_dt,
  csvxls_isNo                     = 'false',
  name                            = 'fileDown',
  url                             = 'dbms/MDC/STAT/standard/MDCSTAT01201')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxKRXGold =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxKRXGold <- tk_xts(df_inxKRXGold, date_var = 일자)
df_inxKRXGold$누적등락률 <- (cumprod(1+(df_inxKRXGold$등락률/100)) -1)

# ==============================================================================
# 금 99.99K
# ==============================================================================
gen_otp_data = list(
  isuCd       = 'KRD040200002',
  strtDd      = v_from_dt,
  endDd       = v_to_dt,
  share       = '1',
  money       = '1',
  csvxls_isNo = 'false',
  name        = 'fileDown',
  url         = 'dbms/MDC/STAT/standard/MDCSTAT15001')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxGold99 =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxGold99 <- tk_xts(df_inxGold99, date_var = 일자)
df_inxGold99$누적등락률 <- (cumprod(1+(df_inxGold99$등락률/100)) -1)

# ==============================================================================
# 미니금 100g
# ==============================================================================
gen_otp_data = list(
  isuCd       = 'KRD040201000',
  strtDd      = v_from_dt,
  endDd       = v_to_dt,
  share       = '1',
  money       = '1',
  csvxls_isNo = 'false',
  name        = 'fileDown',
  url         = 'dbms/MDC/STAT/standard/MDCSTAT15001')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()

df_inxMiniGold =
  POST(download_url,
       query = list(code = otp),
       add_headers(referer = gen_otp_url)) %>%
  read_html(encoding = 'EUC-KR') %>%
  html_text() %>%
  read_csv()

df_inxMiniGold <- tk_xts(df_inxMiniGold, date_var = 일자)
df_inxMiniGold$누적등락률 <- (cumprod(1+(df_inxMiniGold$등락률/100)) -1)


#-------------------------------------------------------------------------------
## save to RData
save(df_inxKOSPI    , file = paste0(getwd(), "/database/IDX_KOSPI.RData"))
save(df_inxKOSPI200 , file = paste0(getwd(), "/database/IDX_KOSPI200.RData"))
save(df_inxKOSDAQ   , file = paste0(getwd(), "/database/IDX_KOSDAQ.RData"))
save(df_inxKOSDAQ150, file = paste0(getwd(), "/database/IDX_KOSDAQ150.RData"))
save(df_inxAmeDolFur, file = paste0(getwd(), "/database/IDX_AmeDolFur.RData"))
save(df_inxKRXGold  , file = paste0(getwd(), "/database/IDX_KRXGold.RData"))
save(df_inxGold99   , file = paste0(getwd(), "/database/IDX_Gold99.RData"))
save(df_inxMiniGold , file = paste0(getwd(), "/database/IDX_MiniGold.RData"))


#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()
