library(shiny)
library(ggplot2)
library(tidyverse)
prem <- read.csv("data/prem_data.csv", header=TRUE)

saveRDS(prem, file = "prem.rds")
prem_rds <- readRDS("prem.rds")
head(prem_rds)


# Define UI for miles per gallon app ----
ui <- fluidPage(
  titlePanel("Soccer"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("Year",
                       "Year:",
                       c("All",
                         unique(as.character(prem_rds$Year))))
    ),
    column(4,
           selectInput("team",
                       "Team:",
                       c("All",
                         unique(as.character(prem_rds$team))))
    )
    ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)


# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- prem_rds
    if (input$Year != "All") {
      data <- data[data$Year == input$Year,]
    }
    if (input$team != "All") {
      data <- data[data$team == input$team,]
    }
    data
  }))
}

shinyApp(ui, server)

