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

    # Convert to time series and daily OHLC object
    theData <- symbolData()
    data_xts <- as.xts(theData[,-1],order.by=as.POSIXct(theData$Date))
    chartSeries(to.daily(data_xts),multi.col=TRUE,type='candles',name=chartName(),theme="white",TA=getTA(input$indicators))
  })
  
  output$table <- renderTable({
    symbolData()
  })
  
  # Output Summary
  output$companyName <- renderText({
    paste('Company:', chartName())
  })
  output$sharesOS <- renderText({
    paste('Shares Outstanding:', "23,233,232")
  })
  output$averageDailyVolume <- renderText({
    paste('Average Daily Volume:',"233,020")
  })
  
  
    
})

