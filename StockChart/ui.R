# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinycssloaders)
library(shinythemes)
library(shinydashboard)

source("GetTA.R")

shinyUI(fluidPage(theme = shinytheme("cerulean"),
  
  # Application title
  titlePanel("Techncial Chart Viewer"),
  verbatimTextOutput("UserId"),

  
  navbarPage("Menu:",
    tabPanel("Home",
             
      sidebarLayout(
    
        sidebarPanel(
          "Enter Symbol With Extension:", 
          textInput("symbol", "TSX = .T,  TSXV = .V, CSE = .C", "TD.T",width="400px"),
          actionButton(inputId="btnChart", label = "Display Chart"),
          tags$br(),tags$br(),
          checkboxGroupInput(inputId = "indicators", label = "Indicators",choices = getTAList())
        ),
    
        mainPanel(
          tabsetPanel(
            tabPanel("Chart",withSpinner(plotOutput("chart",width="100%",height = "700px"))), 
            tabPanel("Summary", 
                 tags$br(),
                 verbatimTextOutput("companyName"),
                 verbatimTextOutput("sharesOS"),
                 verbatimTextOutput("averageDailyVolume")
                 ), 
            tabPanel("Table", tableOutput("table"))
          )
        )
      )
    ),
    tabPanel("Daily List",
             actionButton(inputId="btnRefresh",label="Refresh"),
             tableOutput("CSEList")
    ),
    tabPanel("Edit List",
             dashboardPage(dashboardHeader(disable = T),
                           dashboardSidebar(disable = T),
                           dashboardBody(uiOutput("MainBody")
                           )
             )
                 

             
    ),
    tabPanel("Disclaimer",
             tags$p(),
             titlePanel("This website and the information contained herein is not intended to be a source of advice or creditable analysis. The website is for the sole purpose of demonstrating the capabilities of R Shiny applications.")
    )
  )
))