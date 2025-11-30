# Exercise 2: Custom Output Binding - SOLUTION
# =============================================

library(shiny)
library(dplyr)

# Source our custom component
source("R/statCard.R")

# UI
ui <- fluidPage(
  titlePanel("Exercise 2: Stat Card Output (Solution)"),

  sidebarLayout(
    sidebarPanel(
      h4("This is the working solution!"),
      hr(),

      sliderInput(
        inputId = "metric_slider",
        label = "Performance Score:",
        min = 0,
        max = 100,
        value = 75
      ),

      hr(),

      h5("Thresholds:"),
      tags$ul(
        tags$li(tags$span(style = "color: #28a745;", "Green (good):"), " 80-100"),
        tags$li(tags$span(style = "color: #ffc107;", "Yellow (warning):"), " 50-79"),
        tags$li(tags$span(style = "color: #dc3545;", "Red (bad):"), " 0-49")
      )
    ),

    mainPanel(
      h4("Stat Card Output"),
      statCardOutput("kpi_card", width = "250px")
    )
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
