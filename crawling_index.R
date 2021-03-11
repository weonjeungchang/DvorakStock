## 메모리 청소
rm(list = ls())
gc()

options("scipen" = 100)

if(format(Sys.time() -1, '%H%M%S') < '160000') {
  v_std_dt = format(Sys.Date() -1, '%Y%m%d')
} else {
  v_std_dt = format(Sys.Date() -0, '%Y%m%d')
}
v_from_dt = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(1) - months(0)) %>% str_remove_all('-') # 시작일
v_to_dt   = v_std_dt # 종료일

gen_otp_url  = 'http://data.krx.co.kr/comm/fileDn/GenerateOTP/generate.cmd'
download_url = 'http://data.krx.co.kr/comm/fileDn/download_csv/download.cmd'

# ==============================================================================
# 
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

# ==============================================================================
# 
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

# ==============================================================================
# 
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

# ==============================================================================
# 
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

# ==============================================================================
# 
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

# ==============================================================================
# 
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

# ==============================================================================
# 
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


## save to RData
save(df_inxKOSPI    , file = paste0(getwd(), "/database/INX_KOSPI_"    , v_std_dt, ".RData"))
save(df_inxKOSPI200 , file = paste0(getwd(), "/database/INX_KOSPI200_" , v_std_dt, ".RData"))
save(df_inxKOSDAQ   , file = paste0(getwd(), "/database/INX_KOSDAQ_"   , v_std_dt, ".RData"))
save(df_inxKOSDAQ150, file = paste0(getwd(), "/database/INX_KOSDAQ150_", v_std_dt, ".RData"))
save(df_inxAmeDolFur, file = paste0(getwd(), "/database/INX_AmeDolFur_", v_std_dt, ".RData"))
save(df_inxKRXGold  , file = paste0(getwd(), "/database/INX_KRXGold_"  , v_std_dt, ".RData"))


## remove memory
rm(list=c('gen_otp_data', 'download_url', 'gen_otp_url', 'otp', 'v_from_dt', 'v_std_dt', 'v_to_dt'))
