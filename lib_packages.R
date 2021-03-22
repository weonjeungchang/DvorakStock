# ==============================================================================
# package (sapply)
# ==============================================================================
# install.packages("timetk", lib="/usr/lib64/R/library")
pkg = c('shiny', 'shinyWidgets', 'shinythemes', 'shinydashboard', 'shinyjs',
        'httr', 'rvest', 'readr', 'stringr', 'lubridate', 'readr', 'timetk',
        'highcharter', 'DT', 'dplyr', 'PerformanceAnalytics', 'jsonlite')
sapply(pkg, require, character.only = TRUE)
rm(pkg)
