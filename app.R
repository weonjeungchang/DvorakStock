# ****************************************************************************
# https://github.com/weonjeungchang/DvorakStock.git
# weonjeungchang/DvorakStock
# git config --global user.email "weonjeungchang@gmail.com"
# git config --global user.name "DvorakStock"


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
source('data.R', local = TRUE)

# ==============================================================================
# Define UI for application that draws a histogram
# ==============================================================================
ui <- navbarPage(
  
  "DvorakStock",
  # shinythemes::themeSelector(),
  # theme = shinythemes::shinytheme("darkly"),
  theme = shinythemes::shinytheme("flatly"),
  
  position = "fixed-top",
  
  source('ui_index.R', local = TRUE)$value,
  source('ui_security.R', local = TRUE)$value,
  source('ui_selectionStrategy.R', local = TRUE)$value,
  source('ui_weightAllocation.R', local = TRUE)$value,
  source('ui_WJJang.R', local = TRUE)$value
)

# ==============================================================================
# Define server logic required to draw a histogram
# ==============================================================================
server <- function(input, output) {
  
  source('render_index.R', local = TRUE)
  source('render_security.R', local = TRUE)
  source('render_selectionStrategy.R', local = TRUE)
}

# ==============================================================================
# Run the application 
# ==============================================================================
shinyApp(ui = ui, server = server)


