# Demo App: Custom Shiny Inputs and Outputs
# This app demonstrates both the tri-state toggle input and stat card output

library(shiny)
library(bslib)
library(dplyr)

# Source our custom components
source("R/triStateInput.R")
source("R/statCard.R")

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
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = "flatly"),

  h2("Custom Shiny Bindings Demo"),

  layout_columns(
    col_widths = c(6, 6),

    card(
      card_header("Custom Input: Tri-State Toggle"),
      card_body(
        p("Click the buttons to filter tasks by status."),

        triStateInput(
          inputId = "task_filter",
          label = "Show tasks:",
          choices = c("All" = "all", "Active" = "active", "Completed" = "completed"),
          selected = "all"
        ),

        hr(),

        h5("Filtered Tasks:"),
        tableOutput("task_table"),

        hr(),

        h5("Current filter value (from R):"),
        verbatimTextOutput("filter_value"),

        actionButton("reset_filter", "Reset to 'All'", class = "btn-secondary")
      )
    ),

    card(
      card_header("Custom Output: Stat Card"),
      card_body(
        p("Move the slider to see the card change color based on thresholds."),

        sliderInput(
          inputId = "metric_slider",
          label = "Performance Score:",
          min = 0,
          max = 100,
          value = 75
        ),

        statCardOutput("kpi_card", width = "250px"),

        hr(),

        h5("Thresholds:"),
        tags$ul(
          tags$li(tags$span(class = "text-success", "Green (Good):"), " 80-100"),
          tags$li(tags$span(class = "text-warning", "Yellow (Warning):"), " 50-79"),
          tags$li(tags$span(class = "text-danger", "Red (Bad):"), " 0-49")
        )
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

  # Show the current filter value
  output$filter_value <- renderPrint({
    input$task_filter
  })

  # Reset button handler
  observeEvent(input$reset_filter, {
    updateTriStateInput(session, "task_filter", "all")
  })

  # Render the stat card with conditional styling
  output$kpi_card <- renderStatCard({
    value <- input$metric_slider

    status <- case_when(
      value >= 80 ~ "good",
      value >= 50 ~ "warning",
      TRUE ~ "bad"
    )

    list(
      title = "Performance Score",
      value = value,
      status = status
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
