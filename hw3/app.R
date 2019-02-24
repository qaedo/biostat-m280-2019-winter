library(shiny)
library("tidyverse")
employee <- readRDS("City_Employee_Payroll.rds")
ui <- fluidPage(

  # app title
  titlePanel("Payroll Visualization"),
  
  # sidebar with input/output code
  sidebarLayout(
    
    # sidebar, has input code
    sidebarPanel(
      # Input: select type of pay to view
      selectInput("dataset", "Choose a pay type:",
                  choices = c("base", "over", "other")),
      
      # # Input: Numeric entry for number of employees to view
      # numericInput(inputId = "n",
      #              label = "Number of employees to view",
      #              value = 10),
      # 
      # # Input: Numeric entry for year to view
      # numericInput(inputId = "year",
      #              label = "Year to view",
      #              value = 2017)
      
      actionButton("update", "Update View")
    ),
    
    # panel for output
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "view")
      
    )
  )
)

server <- function(input, output) {
  datasetInput <- eventReactive(input$update, {
    switch(input$dataset,
           "base" = Base.Pay,
           "other" = Overtime.Pay,
           "over" = Other.Pay)
  }, ignoreNULL = FALSE)
  
  output$view <- renderPlot({

    dataset <- employee %>%
      group_by(Year) %>%
      summarize(n = sum(datasetInput()))
    
    hist(x = dataset,
         xlab = "Year",
         ylab = "Salary Amount",
         main = "City Employee Salaries")
    
  })
  
}

shinyApp(ui = ui, server = server)