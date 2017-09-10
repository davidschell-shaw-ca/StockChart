# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("superhero"),
  
  # Application title
  titlePanel("Techncial Chart Viewer"),
  
  sidebarLayout(
    
    sidebarPanel(
    "Enter Symbol With Extension:", 
    textInput("symbol", "TSX = .T,  TSXV = .V, CSE = .C", "TD.T",width="400px"),
    actionButton(inputId="btnChart", label = "Chart"),
    checkboxGroupInput(inputId = "indicators", label = "Indicators",choices =  
                         c("Volume", "RSI", "MFI", "CCI"))),
    
    mainPanel(
    
    withSpinner(plotOutput("chart",width="100%",height = "800px"))))
    #plotOutput("chart")
))