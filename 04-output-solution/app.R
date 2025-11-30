# Exercise 2: Custom Output Binding - SOLUTION
# =============================================

library(shiny)
library(bslib)
library(dplyr)

# Source our custom component
source("R/statCard.R")

# UI
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Exercise 2: Stat Card Output (Solution)",

  sidebar = sidebar(
    title = "This is the working solution!",
    hr(),

    sliderInput(
      inputId = "metric_slider",
      label = "Performance Score:",
      min = 0,
      max = 100,
      value = 75
    ),

    hr(),

    h6("Thresholds:"),
    tags$ul(
      tags$li(tags$span(class = "text-success", "Green (good):"), " 80-100"),
      tags$li(tags$span(class = "text-warning", "Yellow (warning):"), " 50-79"),
      tags$li(tags$span(class = "text-danger", "Red (bad):"), " 0-49")
    )
  ),

  card(
    card_header("Stat Card Output"),
    card_body(statCardOutput("kpi_card", width = "250px"))
  )
)

# Server
server <- function(input, output, session) {
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
