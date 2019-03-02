# FIX DATA SETS SO WE DON'T PLOT TOTAL PAYMENTS ON TOP OF EVERYTHING FML
# loading in needed libraries
library(shiny)
library("tidyverse")
library(ggplot2)
# loading in needed data
employee <- readRDS("./City_Employee_Payroll.rds")
Q2 <- readRDS("./Question2Total.rds")

ui <- fluidPage(

  # app title
  titlePanel("Payroll Visualization"),
  
  # sidebar with input/output code
  sidebarLayout(
    
    # sidebar, has input code
    sidebarPanel(
      selectInput("inMethod", "Choose a method:",
                  choices = c("median", "mean")),
      
      # Input: Numeric entry for number of employees/departments to view
      numericInput(inputId = "inNum",
                   label = "Number of employees/departments to view",
                   value = 5),

      # Input: Numeric entry for year to view
      numericInput(inputId = "inYear",
                   label = "Year to view",
                   value = 2017),
      # update button for question 4 (mean or median payroll)
      actionButton("update", "Update View")
    ),

    # panel for output
    mainPanel(
      tabsetPanel(type = "tabs",
                  # tab for question 2 (total salary)
                  tabPanel("Question 2", plotOutput("plot1")),
                  # tab for question 3 (top n employee)
                  tabPanel("Question 3", tableOutput("table1")),
                  # tab for question 4 (top department earn)
                  tabPanel("Question 4", tableOutput("table2")),
                  # tab for question 5 (top department cost)
                  tabPanel("Question 5", plotOutput("plot2"))
      )
    )
  )
)

server <- function(input, output) {
  methodInput <- eventReactive(input$update, {
    switch(input$inMethod,
           "mean" = "mean4",
           "median" = "median4")
  }, ignoreNULL = FALSE)
  
  # output for question 2 (total salary)
  output$plot1 <- renderPlot({
    ggplot(data = Q2) + geom_col(mapping = aes(x = Year, y = value, 
                                               fill = variable)) +
      ggtitle("City Employee Salary") + labs(x = "Year",
                                             y = "Sum of Salaries") +
      scale_fill_discrete(name="Pay Type",
                          breaks=c("totalPay", "basePay", "overPay",
                                   "otherPay"),
                          labels=c("Total Payments", "Base Pay", 
                                   "Overtime Pay", "Other Pay"))
  })
  
  # output for question 3, top n employees
  output$table1 <- renderTable({
    dataset <- employee
    Q3 <- dataset %>%
      filter(Year == input$inYear) %>%
      arrange(desc(Total_Payments)) %>%
      head(input$inNum) %>%
      rename("Department Title" = Department_Title, "Job Class Title" =
               Job_Class_Title, "Total Payments" = Total_Payments, "Base Pay" =
               Base_Pay, "Overtime Pay" = Overtime_Pay, "Other Pay" = Other_Pay)
  },
  colnames = TRUE)
  
  # output for question 4, top n department
  output$table2 <- renderTable({
    inputMethod <- methodInput()
    dataset <- employee
    if (inputMethod == "mean4") {
      Q4 <- dataset %>%
        filter(Year == input$inYear) %>%
        group_by(Department_Title) %>%
        summarize(total = mean(Total_Payments, na.rm = TRUE),
                  base = mean(Base_Pay, na.rm = TRUE),
                  over = mean(Overtime_Pay, na.rm = TRUE),
                  other = mean(Other_Pay, na.rm = TRUE)) %>%
        arrange(desc(total)) %>%
        head(input$inNum)
    } else {
      Q4 <- dataset %>%
        filter(Year == input$inYear) %>%
        group_by(Department_Title) %>%
        summarize(total = median(Total_Payments, na.rm = TRUE),
                  base = median(Base_Pay, na.rm = TRUE),
                  over = median(Overtime_Pay, na.rm = TRUE),
                  other = median(Other_Pay, na.rm = TRUE)) %>%
        arrange(desc(total)) %>%
        head(input$inNum)
    }
  })
  
  # output for question 5 (top department cost)
  output$plot2 <- renderPlot({
    # summarizing payment totals
    total_data_5 <- employee %>%
      group_by(Year, Department_Title) %>%
      summarise(totalPay = sum(Total_Payments, na.rm = TRUE),
                basePay = sum(Base_Pay, na.rm = TRUE),
                overPay = sum(Overtime_Pay, na.rm = TRUE),
                otherPay = sum(Other_Pay, na.rm = TRUE))
    # converting data to data frame
    as.data.frame(total_data_5)
    # transposing data frame from wide to long
    total_long_5 <- melt(total_data_5, id.vars = c("Year", "Department_Title"))
    
    # finding top departments based on total payments and n input
    vector5 <- total_long_5 %>%
      filter(Year == input$inYear, variable == "totalPay") %>%
      group_by(Department_Title) %>%
      arrange(desc(value)) %>%
      head(input$inNum)
    # filtering data by top departments in vector5
    Q5 <- subset(total_long_5, total_long_5$Department_Title %in% 
                     vector5$Department_Title & Year == input$inYear)
    
    # graphing filtered data
    ggplot(data = Q5) + geom_col(mapping = aes(x = Department_Title, y = value, 
                                               fill = variable)) +
      ggtitle("Department Salaries") + labs(x = "Department", 
                                            y = "Sum of Salaries") +
      scale_fill_discrete(name="Pay Type",
                          breaks=c("totalPay", "basePay", "overPay", 
                                   "otherPay"),
                          labels=c("Total Payments", "Base Pay", 
                                   "Overtime Pay", "Other Pay")) +
      theme(axis.text.x = element_text(angle = 90))
  })
  
}

shinyApp(ui = ui, server = server)