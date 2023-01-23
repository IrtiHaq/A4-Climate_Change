
# Libraries
library(shiny)
library(plotly)

#load ui
source("app_ui.R")

#load server
source("app_server.R")

# Create App
shinyApp(ui = ui, server = server)