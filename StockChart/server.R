# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(quantmod)
source("GetChartData.R")

shinyServer(function(input, output, session) {
  
  
  output$chart <- renderPlot({
    
    sym <- toupper(input$symbol)
    if ((grepl(".V",sym) == TRUE) || (grepl(".T",sym) == TRUE) || (grepl(".C",sym) == TRUE))
    {
      extension <- ""
      if (grepl(".V",sym) == TRUE)
      {
        extension = "CVE"
        sym <- gsub(".V","",sym)
      }
      else if (grepl(".T",sym) == TRUE)
      {
        extension = "TSE"
        sym <- gsub(".T","",sym)
      }
      else
      {
        extension = "CNSX"
        sym <- gsub(".C","",sym)  
      }
      #setSymbolLookup(sym='yahoo')
      #getSymbols(sym)
      #symbolData <- last(eval(parse(text = sym)),90)
      symbolData <- getChartData(sym,extension)
      candleChart(symbolData,multi.col=TRUE,theme="white",TA="addVo();addMFI();addRSI();addCCI()")
    }
  })
})
