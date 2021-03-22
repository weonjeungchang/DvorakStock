
#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()

options("scipen" = 100)

v_std_dt = format(Sys.Date() -0, '%Y%m%d')
v_pre_dt = format(Sys.Date() -1, '%Y%m%d')

v_from_dt = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(6)) %>% str_remove_all('-') # 시작일
v_to_dt   = v_std_dt # 종료일

getJsonData.url = 'http://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd'

# ==============================================================================
# 모멘텀
# ==============================================================================
## KOSPI
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD02801',
                         type        = '3',
                         indType     = '1001',
                         visibleCnt  = '10',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)
Momentum_KS <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

Momentum_KS <- Momentum_KS$block1

## KOSDAQ
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD02801',
                         type        = '4',
                         indType     = '2001',
                         visibleCnt  = '10',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)
Momentum_KQ <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

Momentum_KQ <- Momentum_KQ$block1


#-------------------------------------------------------------------------------
INV_MomentumItem <- rbind(Momentum_KS, Momentum_KQ)
colnames(INV_MomentumItem) <- 
  c('시장구분', '종목코드', '종목명', '모멘텀_6개월', '모멘텀_12개월', '모멘텀_과거', 
    '현재가', '시가', '고가', '저가', "FLUC_TP", "대비", "등락률", "거래량", "거래대금", "시가총액")
INV_MomentumItem$STD_DT <- v_std_dt

#-------------------------------------------------------------------------------
## save to RData
save(INV_MomentumItem,
     file = paste0(getwd(), "/database/INV_MomentumItem.RData"))


# ==============================================================================
# 단기반전
# ==============================================================================
## KOSPI
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD02901',
                         type        = '3',
                         indType     = '1001',
                         visibleCnt  = '15',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)

reversal_shortTerm_KS <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

reversal_shortTerm_KS <- reversal_shortTerm_KS$block1

## KOSDAQ
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD02901',
                         type        = '4',
                         indType     = '2001',
                         visibleCnt  = '15',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)

reversal_shortTerm_KQ <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

reversal_shortTerm_KQ <- reversal_shortTerm_KQ$block1


#-------------------------------------------------------------------------------
INV_reversalShortTerm <- rbind(reversal_shortTerm_KS, reversal_shortTerm_KQ)
colnames(INV_reversalShortTerm) <- 
  c('시장구분', '종목코드', '종목명', '단기반전_과거수익률', '단기반전_직전수익률', '단기반전_반전여부', 
    '현재가', '시가', '고가', '저가', "FLUC_TP", "대비", "등락률", "거래량", "거래대금", "시가총액")
INV_reversalShortTerm$STD_DT <- v_std_dt

#-------------------------------------------------------------------------------
## save to RData
save(INV_reversalShortTerm,
     file = paste0(getwd(), "/database/INV_reversalShortTerm.RData"))


# ==============================================================================
# 장기반전
# ==============================================================================
## KOSPI
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD03001',
                         type        = '3',
                         indType     = '1001',
                         visibleCnt  = '15',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)

reversal_longTerm_KS <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

reversal_longTerm_KS <- reversal_longTerm_KS$block1

## KOSDAQ
getJsonData.query = list(bld         = 'dbms/MDC/HARD/MDCHARD03001',
                         type        = '4',
                         indType     = '2001',
                         visibleCnt  = '15',
                         csvxls_isNo = 'false')
getJsonData.request <- POST(getJsonData.url,
                            query = getJsonData.query)

reversal_longTerm_KQ <-
  getJsonData.request$content %>%
  rawToChar() %>%
  fromJSON()

reversal_longTerm_KQ <- reversal_longTerm_KQ$block1


#-------------------------------------------------------------------------------
INV_reversalLongTerm <- rbind(reversal_longTerm_KS, reversal_longTerm_KQ)
colnames(INV_reversalLongTerm) <- 
  c('시장구분', '종목코드', '종목명', '장기반전_과거수익률', '장기반전_직전수익률', '장기반전_반전여부', 
    '현재가', '시가', '고가', '저가', "FLUC_TP", "대비", "등락률", "거래량", "거래대금", "시가총액")
INV_reversalLongTerm$STD_DT <- v_std_dt

#-------------------------------------------------------------------------------
## save to RData
save(INV_reversalLongTerm,
     file = paste0(getwd(), "/database/INV_reversalLongTerm.RData"))


#-------------------------------------------------------------------------------
## 메모리 청소
# rm(list = ls())
# gc()


