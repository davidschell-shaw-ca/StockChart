# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


library(shiny)
library(quantmod)
library(data.table)
library(DT)
source("GetChartData.R")
source("SymbolObj.R")
source("GetTA.R")

shinyServer(function(input, output, session) {
  
  output$UserId <- renderText({Sys.getenv("USERNAME")})
  
  
  
  output$CSEList <- renderTable({
    #read.csv('/data/cse.csv')
    symbolList()
  })
  
  symbolData <-  eventReactive(input$btnChart,{
      chartData <- getChartData(input$symbol)
  })

  chartName <- eventReactive(input$btnChart,{
    symbol <- getSymbol(input$symbol)
    symbol@Title
  })

  symbolList <- eventReactive(input$btnRefresh,{
    readRDS('data/symbols.rds')
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
  
  ## New Code
  
  vals<-reactiveValues()
  vals$Data<-data.table(
    #Symbol = c('FAT.C','GRO.V','DLS.V'), 
    #CompanyName = c('Far Resources','Grow UP','Dealnet'),
    #LastPrice=c(.23,.105,.165),
    #Active=c(FALSE,TRUE,TRUE)
    readRDS('data/symbols.rds')
  )
  
  output$MainBody<-renderUI({
    fluidPage(
      box(width=12,
          h3(strong("Edit Stock Symbol List"),align="center"),
          hr(),
          column(1,HTML('<div>'),actionButton(inputId = "Save", label = "Save List"),HTML('</div>')),
          column(6,offset = 5,
                 HTML('<div class="btn-group" role="group" aria-label="Basic example">'),
                 actionButton(inputId = "Add_row_head",label = "Add a new row"),
                 actionButton(inputId = "Del_row_head",label = "Delete selected rows"),
                 actionButton(inputId = "Compare_row_head",label = "Compare selected rows"),
                 HTML('</div>')
          ),
          HTML('<br><br>'),
          column(12,dataTableOutput("Main_table")),
          tags$script(HTML('$(document).on("click", "input", function () {
                           var checkboxes = document.getElementsByName("row_selected");
                           var checkboxesChecked = [];
                           for (var i=0; i<checkboxes.length; i++) {
                           if (checkboxes[i].checked) {
                           checkboxesChecked.push(checkboxes[i].value);
                           }
                           }
                           Shiny.onInputChange("checked_rows",checkboxesChecked);
  })')),
      tags$script("$(document).on('click', '#Main_table button', function () {
                  Shiny.onInputChange('lastClickId',this.id);
                  Shiny.onInputChange('lastClick', Math.random())
});")

      )
      )
    })
  
  output$Main_table<-renderDataTable({
    DT=vals$Data
    DT[["Select"]]<-paste0('<input type="checkbox" name="row_selected" value="Row',1:nrow(vals$Data),'"><br>')
    
    DT[["Actions"]]<-
      paste0('
             <div class="btn-group" role="group" aria-label="Basic example">
             <button type="button" class="btn btn-secondary delete" id=delete_',1:nrow(vals$Data),'>Delete</button>
             <button type="button" class="btn btn-secondary modify"id=modify_',1:nrow(vals$Data),'>Modify</button>
             </div>
             
             ')
    datatable(DT,
              escape=F)}
      )
  
  observeEvent(input$Save,{
    saveRDS(vals$Data,"data/symbols.rds")  
    symbolList <- vals$Data
  })
  
  observeEvent(input$Add_row_head,{
    new_row=data.frame(
      Symbol="Symbol",
      CompanyName="CompanyName",
      LastPrice=.23,
      Active=TRUE)
    vals$Data<-rbind(vals$Data,new_row)
  })
  
  
  observeEvent(input$Del_row_head,{
    row_to_del=as.numeric(gsub("Row","",input$checked_rows))
    
    vals$Data=vals$Data[-row_to_del]}
  )
  
  
  
  ###Brand visualisation 
  observeEvent(input$Compare_row_head,{
    row_to_del=as.numeric(gsub("Row","",input$checked_rows))
    number_brands=length(row_to_del)
    vals$fake_sales=data.table(
      month=rep(1:12,number_brands),sales=round(rnorm(12*number_brands,1000,1000)^2)/12,
      Brands=rep(vals$Data[row_to_del,Symbol],each=12)
    )
    vals$fake_sales[,Symbol:=as.factor(Brands)]
    showModal(fake_sales_modal)
  }
  )
  
  
  fake_sales_modal<-modalDialog(
    fluidPage(
      h3(strong("Monthly sales of selected brands"),align="center"),
      plotOutput('sales_plot')
    ),
    size="l"
  )
  
  output$sales_plot<-renderPlot({
    require(ggplot2)
    ggplot(vals$fake_sales,aes(x=month,y=sales,color=Brands))+geom_line()
  })
  
  ##Managing in row deletion
  modal_modify<-modalDialog(
    fluidPage(
      h3(strong("Row modification"),align="center"),
      hr(),
      dataTableOutput('row_modif'),
      actionButton("save_changes","Save changes"),
      
      tags$script(HTML("$(document).on('click', '#save_changes', function () {
                       var list_value=[]
                       for (i = 0; i < $( '.new_input' ).length; i++)
                       {
                       list_value.push($( '.new_input' )[i].value)
                       }
                       Shiny.onInputChange('newValue', list_value)
                       });"))
    ),
    size="l"
      )
  
  
  observeEvent(input$lastClick,
               {
                 if (input$lastClickId%like%"delete")
                 {
                   row_to_del=as.numeric(gsub("delete_","",input$lastClickId))
                   vals$Data=vals$Data[-row_to_del]
                 }
                 else if (input$lastClickId%like%"modify")
                 {
                   showModal(modal_modify)
                 }
               }
  )
  
  output$row_modif<-renderDataTable({
    selected_row=as.numeric(gsub("modify_","",input$lastClickId))
    old_row=vals$Data[selected_row]
    row_change=list()
    for (i in colnames(old_row))
    {
      if (is.numeric(vals$Data[[i]]))
      {
        row_change[[i]]<-paste0('<input class="new_input" type="number" id=new_',i,'><br>')
      }
      else
        row_change[[i]]<-paste0('<input class="new_input" type="text" id=new_',i,'><br>')
    }
    row_change=as.data.table(row_change)
    setnames(row_change,colnames(old_row))
    DT=rbind(old_row,row_change)
    rownames(DT)<-c("Current values","New values")
    DT
    
  },escape=F,options=list(dom='t',ordering=F),selection="none"
  )
  
  
  observeEvent(input$newValue,
               {
                 newValue=lapply(input$newValue, function(col) {
                   if (suppressWarnings(all(!is.na(as.numeric(as.character(col)))))) {
                     as.numeric(as.character(col))
                   } else {
                     col
                   }
                 })
                 DF=data.frame(lapply(newValue, function(x) t(data.frame(x))))
                 colnames(DF)=colnames(vals$Data)
                 vals$Data[as.numeric(gsub("modify_","",input$lastClickId))]<-DF
                 
               }
  )
  
})

