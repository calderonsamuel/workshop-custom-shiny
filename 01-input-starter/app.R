# Exercise 1: Custom Input Binding - Tri-State Toggle
# ====================================================
#
# YOUR TASK: Complete the JavaScript binding in www/js/tristate.js
#
# This app won't work until you implement the binding methods!
# Open www/js/tristate.js and follow the instructions there.

library(shiny)
library(bslib)
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
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Exercise 1: Tri-State Toggle Input",

  sidebar = sidebar(
    title = "Instructions",
    p("Complete the JavaScript binding in", code("www/js/tristate.js")),
    p("When working, the toggle below should:"),
    tags$ul(
      tags$li("Update when you click each option"),
      tags$li("Filter the task table"),
      tags$li("Show the current value in the debug box")
    ),
    hr(),
    triStateInput(
      inputId = "task_filter",
      label = "Filter tasks:",
      choices = c("All" = "all", "Active" = "active", "Completed" = "completed"),
      selected = "all"
    ),
    hr(),
    h6("Debug: Current value from R"),
    verbatimTextOutput("filter_value"),
    hr(),
    actionButton("reset_filter", "Reset to 'All'", class = "btn-secondary"),
    p(class = "text-muted mt-2", "This button tests updateTriStateInput()")
  ),

  card(
    card_header("Filtered Tasks"),
    card_body(tableOutput("task_table"))
  ),

  card(
    card_header("Progress Checklist"),
    card_body(
      class = "bg-light",
      tags$p(tags$strong("After implementing find() and getValue():")),
      tags$ul(
        tags$li("The 'Current value' box should show 'all' (not NULL)")
      ),
      tags$p(tags$strong("After implementing subscribe():")),
      tags$ul(
        tags$li("Clicking options should update the value and filter the table")
      ),
      tags$p(tags$strong("After implementing setValue() and receiveMessage():")),
      tags$ul(
        tags$li("The 'Reset to All' button should work")
      )
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

  # Show the current filter value (for debugging)
  output$filter_value <- renderPrint({
    input$task_filter
  })

  # Reset button handler - tests updateTriStateInput
  observeEvent(input$reset_filter, {
    updateTriStateInput(session, "task_filter", "all")
  })
}

# Run the app
shinyApp(ui = ui, server = server)
