# Exercise 2: Custom Output Binding - Stat Card
# ==============================================
#
# YOUR TASK: Complete the JavaScript binding in www/js/statcard.js
#
# This app won't work until you implement the binding methods!
# Open www/js/statcard.js and follow the instructions there.

library(shiny)
library(dplyr)

# Source our custom component
source("R/statCard.R")

# UI
ui <- fluidPage(
  titlePanel("Exercise 2: Stat Card Output"),

  sidebarLayout(
    sidebarPanel(
      h4("Instructions"),
      p("Complete the JavaScript binding in", code("www/js/statcard.js")),
      p("When working, the stat card should:"),
      tags$ul(
        tags$li("Display the title and value"),
        tags$li("Change color based on the score threshold")
      ),
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
      statCardOutput("kpi_card", width = "250px"),

      hr(),

      h5("Progress Checklist"),
      tags$div(
        class = "well",
        tags$p(tags$strong("After implementing find():")),
        tags$ul(
          tags$li("No JavaScript errors in console")
        ),
        tags$p(tags$strong("After implementing renderValue():")),
        tags$ul(
          tags$li("Card shows the title and value"),
          tags$li("Moving the slider updates the card"),
          tags$li("Card color changes based on thresholds")
        )
      ),

      hr(),

      h5("Debug: Data being sent to JavaScript"),
      verbatimTextOutput("debug_output")
    )
  )
)

# Server
server <- function(input, output, session) {
  # Compute the card data reactively
  card_data <- reactive({
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

  # Render the stat card
  output$kpi_card <- renderStatCard({
    card_data()
  })

  # Debug output to show what data is being sent
  output$debug_output <- renderPrint({
    card_data()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
