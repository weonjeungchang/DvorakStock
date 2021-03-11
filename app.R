
# 퀀트 투자 : 포트폴리오 운용 전략 / 트레이딩 전략
# 01. 포트폴리오 운용 전략 :
#   과거 주식 시장을 분석해 좋은 주식의 기준을 찾아낸 후 해당 기준에 만족하는 종목을 매수하거나, 이와 반대에 있는 나쁜 주식을 공매도하기도 합니다. 투자의 속도가 느리며, 다수의 종목을 하나의 포트폴리오로 구성해 운용하는 특징이 있습니다.
# 02. 트레이딩 전략 :
#   단기간에 발생되는 주식의 움직임을 연구한 후 예측해 매수 혹은 매도하는 전략입니다. 투자의 속도가 빠르며 소수의 종목을 대상으로 합니다.
# 
# 수익률에 영향을 미치는 요소를 팩터(Factor)라고 합니다.



## 메모리 청소
rm(list = ls())
gc()

# ==============================================================================
# package (sapply)
# ==============================================================================
source('lib_packages.R', local = TRUE, encoding = 'utf-8')

# ==============================================================================
# data
# ==============================================================================
if(format(Sys.time() -1, '%H%M%S') < '160000') {
  v_std_dt = format(Sys.Date() -1, '%Y%m%d')
} else {
  v_std_dt = format(Sys.Date() -0, '%Y%m%d')
}
## index
load(paste0(getwd(), '/database/INX_KOSPI_'    , v_std_dt, '.RData'))
load(paste0(getwd(), '/database/INX_KOSDAQ_'   , v_std_dt, '.RData'))
load(paste0(getwd(), '/database/INX_KOSPI200_' , v_std_dt, '.RData'))
load(paste0(getwd(), '/database/INX_KOSDAQ150_', v_std_dt, '.RData'))
load(paste0(getwd(), '/database/INX_AmeDolFur_', v_std_dt, '.RData'))
load(paste0(getwd(), '/database/INX_KRXGold_'  , v_std_dt, '.RData'))
## ticker
v_file_nm <- paste0("~/database/KOR_ticker_", format(Sys.Date(), '%Y%m%d'), ".RData")
if(file.exists(v_file_nm)) {
  # load(file=v_file_nm)
} else {
  # source('crawling_stock.R', local = TRUE, encoding = 'utf-8')
}
rm(v_file_nm)


# ==============================================================================
# Define UI for application that draws a histogram
# ==============================================================================
ui <- navbarPage(
  
  "DvorakStock",
  # shinythemes::themeSelector(),
  # theme = shinythemes::shinytheme("darkly"),
  theme = shinythemes::shinytheme("flatly"),
  
  position = "fixed-top", header = NULL,
  
  source('output_index.R', local = TRUE)$value
)


# ==============================================================================
# Define server logic required to draw a histogram
# ==============================================================================
server <- function(input, output) {
  
  source('render_index.R', local = TRUE)
}


# ==============================================================================
# Run the application 
# ==============================================================================
shinyApp(ui = ui, server = server)


