# loading in needed libraries
library(shiny)
library("tidyverse")
library(ggplot2)
library(reshape2)
# loading in needed data
employee <- readRDS("./City_Employee_Payroll.rds")

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
      actionButton("update", "Update Q4 Method")
    ),

    # panel for output
    mainPanel(
      tabsetPanel(type = "tabs",
                  # tab for question 2 (total salary)
                  tabPanel("Question 2", plotOutput("plot1")),
                  # tab for question 3 (top n employee)
                  tabPanel("Question 3", tableOutput("table1")),
                  # tab for question 4 (top department earn)
                  tabPanel("Question 4", plotOutput("plot2")),
                  # tab for question 5 (top department cost)
                  tabPanel("Question 5", plotOutput("plot3")),
                  # tab for question 6 (my choice)
                  tabPanel("Question 6", plotOutput("plot4"))
      )
    )
  )
)

server <- function(input, output) {
  # reactive expression for question 4 (mean/median)
  methodInput <- eventReactive(input$update, {
    switch(input$inMethod,
           "mean" = "mean4",
           "median" = "median4")
  }, ignoreNULL = FALSE)
  
  # output for question 2 (total salary)
  output$plot1 <- renderPlot({
    # setting up data to be graphed
    Q2 <- employee %>%
      group_by(Year) %>%
      # summing the different types of pay by year
      summarise(basePay = sum(Base_Pay, na.rm = TRUE),
                overPay = sum(Overtime_Pay, na.rm = TRUE),
                otherPay = sum(Other_Pay, na.rm = TRUE)) %>%
      # transforming into data frame to convert into long format
    as.data.frame(Q2) %>%
      # convert into long format
      melt(id.vars = "Year")
    # graphing output
    ggplot(data = Q2) + geom_col(mapping = aes(x = Year, y = value, 
                                               fill = variable)) +
      ggtitle("City Employee Salary") + labs(x = "Year",
                                             y = "Sum of Salaries") +
      scale_fill_discrete(name="Pay Type",
                          breaks=c("basePay", "overPay", "otherPay"),
                          labels=c("Base Pay", "Overtime Pay", "Other Pay"))
  })
  
  # output for question 3, top n employees
  output$table1 <- renderTable({
    dataset <- employee
    Q3 <- dataset %>%
      # filtering by user's chosen year
      filter(Year == input$inYear) %>%
      # arranging data by Total_Payments, highest first
      arrange(desc(Total_Payments)) %>%
      # selecting employoees by user's chosen n
      head(input$inNum) %>%
      # displaying data entries
      rename("Department Title" = Department_Title, "Record Number" = 
               Record_Number, "Job Class Title" = Job_Class_Title,
             "Total Payments" = Total_Payments, "Base Pay" = 
               Base_Pay, "Overtime Pay" = Overtime_Pay, "Other Pay" = Other_Pay)
  },
  colnames = TRUE)
  
  # output for question 4, top n department
  output$plot2 <- renderPlot({
    inputMethod <- methodInput()
    # setting up if statement to generate dataset based on user's chosen method
    if (inputMethod == "mean4") {
      Q4 <- employee %>%
        # filtering by user's chosen year
        filter(Year == input$inYear) %>%
        # grouping by department
        group_by(Department_Title) %>%
        # finding means of payment types by department
        summarize(total = mean(Total_Payments, na.rm = TRUE),
                  base = mean(Base_Pay, na.rm = TRUE),
                  over = mean(Overtime_Pay, na.rm = TRUE),
                  other = mean(Other_Pay, na.rm = TRUE)) %>%
        # arranging data, highest value first
        arrange(desc(total)) %>%
        # selecting departments by user's chosen n
        head(input$inNum) %>%
        # converting into data frame
        as.data.frame() %>%
        # transforming into long format
        melt(id.vars = "Department_Title")
      # graphing output
      ggplot(data = Q4) + geom_col(mapping = aes(x = Department_Title,
                                                 y = value, fill = variable),
                                   position = "dodge", stat = "identity") +
        ggtitle("City Employee Salary") + labs(x = "Department Title",
                                               y = "Mean Salary") +
        scale_fill_discrete(name="Pay Type",
                            breaks=c("total", "base", "over", 
                                     "other"),
                            labels=c("Total Payments", "Base Pay", 
                                     "Overtime Pay", "Other Pay")) +
        theme(axis.text.x = element_text(angle = 45))
    } else {
      # creating vector of department names based on user's chosen year
      vector4 <- employee %>%
        filter(Year == input$inYear) %>%
        group_by(Department_Title) %>%
        summarize(total = sum(Total_Payments)) %>%
        arrange(desc(total)) %>%
        head(input$inNum)
      # filtering data based on departments in vector4
      Q4 <- subset(employee, employee$Department_Title %in% 
                     vector4$Department_Title & Year == input$inYear) %>%
        # selecting variables to transform into long
        select(Department_Title, Total_Payments, Base_Pay, Overtime_Pay,
               Other_Pay) %>%
        # grouping by department
        group_by(Department_Title) %>%
        # transforming into long format
        melt(id.vars = "Department_Title")
      # plotting output
      ggplot(data = Q4) + geom_boxplot(mapping = aes(Department_Title, value,
                                                     fill = variable),
                                       outlier.shape = NA) +
        ggtitle("City Employee Salary") + labs(x = "Department Title",
                                               y = "Median Salary") +
        scale_fill_discrete(name="Pay Type",
                            breaks=c("Total_Payments", "Base_Pay",
                                     "Overtime_Pay", "Other_Pay"),
                            labels=c("Total Payments", "Base Pay", 
                                     "Overtime Pay", "Other Pay")) +
        theme(axis.text.x = element_text(angle = 90))
    }
  })
  
  # output for question 5 (top department cost)
  output$plot3 <- renderPlot({
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
                     vector5$Department_Title & Year == input$inYear &
                   variable != "totalPay")
    
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
  
  # output for question 6 (my choice)
  output$plot4 <- renderPlot({
    Q6 <- employee %>%
      group_by(Job_Class_Title) %>%
      summarise(n = n()) %>%
      arrange(desc(n)) %>%
      head(input$inNum)
    
    # graphing filtered data
    ggplot(data = Q6) + geom_col(mapping = aes(x = Job_Class_Title, y = n)) +
      ggtitle("Number of Employees by Job") + labs(x = "Job Class Title", 
                                            y = "Number of Employees") +
      theme(axis.text.x = element_text(angle = 90))
  })
  
}

shinyApp(ui = ui, server = server)