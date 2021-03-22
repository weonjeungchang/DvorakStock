
#-------------------------------------------------------------------------------
## 메모리 청소
rm(list = ls())
gc()

options("scipen" = 100)

v_std_dt = format(Sys.Date() -0, '%Y%m%d')
v_pre_dt = format(Sys.Date() -1, '%Y%m%d')

v_from_dt = (as.POSIXct(v_std_dt, format = '%Y%m%d') - years(0) - months(6)) %>% str_remove_all('-') # 시작일
v_to_dt   = v_std_dt # 종료일

# ==============================================================================
# index
# ==============================================================================
load(paste0(getwd(), '/database/IDX_KOSPI.RData'))
v_idx_dt <- index(tail(df_inxKOSPI, n=1)) %>% str_remove_all('-')

if(v_std_dt != v_idx_dt) {
  source('crawling_index.R', local = TRUE, encoding = 'utf-8')
}

load(paste0(getwd(), '/database/IDX_KOSPI.RData'))
load(paste0(getwd(), '/database/IDX_KOSDAQ.RData'))
load(paste0(getwd(), '/database/IDX_KOSPI200.RData'))
load(paste0(getwd(), '/database/IDX_KOSDAQ150.RData'))
load(paste0(getwd(), '/database/IDX_AmeDolFur.RData'))
load(paste0(getwd(), '/database/IDX_KRXGold.RData'))
load(paste0(getwd(), '/database/IDX_Gold99.RData'))
load(paste0(getwd(), '/database/IDX_MiniGold.RData'))

# ==============================================================================
# 상한가, 하한가
# ==============================================================================
load(paste0(getwd(), '/database/STK_upperLimit.RData'))
v_ul_dt <- STK_upperLimit[1, c('STD_DT')]

if(v_std_dt != v_ul_dt) {
  source('crawling_stock.R', local = TRUE, encoding = 'utf-8')
}

load(paste0(getwd(), '/database/STK_upperLimit.RData'))
load(paste0(getwd(), '/database/STK_lowerLimit.RData'))

# ==============================================================================
# ticker
# ==============================================================================
load(paste0(getwd(), '/database/KOR_ticker.RData'))
v_ticker_dt <- KOR_ticker[1,]$STD_DT

if(v_std_dt != v_ticker_dt) {
  source('crawling_stock.R', local = TRUE, encoding = 'utf-8')
}

load(paste0(getwd(), '/database/KOR_ticker.RData'))

# ==============================================================================
# 투자정보
# ==============================================================================
load(paste0(getwd(), '/database/INV_MomentumItem.RData'))
load(paste0(getwd(), '/database/INV_reversalShortTerm.RData'))
load(paste0(getwd(), '/database/INV_reversalLongTerm.RData'))


