# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)

shinyServer(function(input, output, session) {
  
  output$distPlot <- renderPlot({
    sym <- toupper(input$symbol)
    #if (grepl(sym, ".V") || grepl(sym, ".TO"))
    #{
    setSymbolLookup(sym='yahoo')
    getSymbols(sym)
    symbolData <- last(eval(parse(text = sym)),90)
    candleChart(symbolData,multi.col=TRUE,theme="white",TA="addVo();addMFI();addRSI();addCCI()")
    #}
  })
  
  
})
