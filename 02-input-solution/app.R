# Exercise 1: Custom Input Binding - SOLUTION
# ============================================

library(shiny)
library(dplyr)

# Source our custom component
source("R/triStateInput.R")

# Sample data for the demo
tasks <- data.frame(
  id = 1:10,
  task = c(
    "Review pull request",
    "Write documentation",
    "Fix login bug",
    "Update dependencies",
    "Design new feature",
    "Code review",
    "Deploy to staging",
    "Write unit tests",
    "Refactor API",
    "Update README"
  ),
  status = c(
    "completed", "active", "active", "completed", "active",
    "completed", "completed", "active", "completed", "active"
  ),
  stringsAsFactors = FALSE
)

# UI
ui <- fluidPage(
  titlePanel("Exercise 1: Tri-State Toggle Input (Solution)"),

  sidebarLayout(
    sidebarPanel(
      h4("This is the working solution!"),
      hr(),
      triStateInput(
        inputId = "task_filter",
        label = "Filter tasks:",
        choices = c("All" = "all", "Active" = "active", "Completed" = "completed"),
        selected = "all"
      ),
      hr(),
      h5("Current value from R:"),
      verbatimTextOutput("filter_value"),
      hr(),
      actionButton("reset_filter", "Reset to 'All'")
    ),

    mainPanel(
      h4("Filtered Tasks"),
      tableOutput("task_table")
    )
  )
)

# Server
server <- function(input, output, session) {
  # Filter tasks based on the tri-state input
  filtered_tasks <- reactive({
    filter_val <- input$task_filter

    if (is.null(filter_val) || filter_val == "all") {
      tasks
    } else {
      tasks %>% filter(status == filter_val)
    }
  })

  # Render the filtered task table
  output$task_table <- renderTable({
    filtered_tasks() %>%
      select(Task = task, Status = status)
  })

  # Show the current filter value
  output$filter_value <- renderPrint({
    input$task_filter
  })

  # Reset button handler
  observeEvent(input$reset_filter, {
    updateTriStateInput(session, "task_filter", "all")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
