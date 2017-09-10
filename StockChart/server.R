# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(quantmod)
source("GetChartData.R")
source("SymbolObj.R")
source("GetTA.R")

shinyServer(function(input, output, session) {
  
  symbolData <-  eventReactive(input$btnChart,{
      getChartData(input$symbol)
  })
  
  chartName <- eventReactive(input$btnChart,{
    symbol <- getSymbol(input$symbol)
    symbol@Title
  })

  output$chart <- renderPlot({
      #chartSeries(symbolData(),multi.col=TRUE,type='candles',name=chartName(),theme="white",TA="addBBands();addVo();addMFI();addRSI();addCCI()")
    chartSeries(symbolData(),multi.col=TRUE,type='candles',name=chartName(),theme="white",TA=getTA(input$indicators))
    
  })
})

