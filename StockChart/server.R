# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(quantmod)
source("GetChartData.R")

shinyServer(function(input, output, session) {
  
  symbolData <-  eventReactive(input$btnChart,{
      getChartData(input$symbol)
  })
  
  chartName <- eventReactive(input$btnChart,{
    input$symbol
  })
  output$chart <- renderPlot({
    

      #setSymbolLookup(sym='yahoo')
      #getSymbols(sym)
      #symbolData <- last(eval(parse(text = sym)),90)

      chartSeries(symbolData(),multi.col=TRUE,type='candles',name=chartName(),theme="white",TA="addBBands();addVo();addMFI();addRSI();addCCI()")

  })
})
