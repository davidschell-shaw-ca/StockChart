# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Over Sold/Bought Techncial Chart Viewer"),
  
  shinyUI(fluidPage(
    textInput("symbol", "Enter Symbol With Extension: TSX:.T, TSXV:.V, CSE:.C", "TD.T"),
    
    plotOutput("chart")
  ))
))