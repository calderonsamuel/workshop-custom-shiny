# Ejercicio 2: Output Binding Personalizado - SOLUCIÓN
# =====================================================

library(shiny)
library(bslib)
library(dplyr)

# Cargar nuestro componente personalizado
source("R/statCard.R")

# UI
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Ejercicio 2: Output Tarjeta de Estadísticas (Solución)",

  sidebar = sidebar(
    title = "¡Esta es la solución funcionando!",
    hr(),

    sliderInput(
      inputId = "metric_slider",
      label = "Puntuación de Rendimiento:",
      min = 0,
      max = 100,
      value = 75
    ),

    hr(),

    h6("Umbrales:"),
    tags$ul(
      tags$li(tags$span(class = "text-success", "Verde (bueno):"), " 80-100"),
      tags$li(tags$span(class = "text-warning", "Amarillo (advertencia):"), " 50-79"),
      tags$li(tags$span(class = "text-danger", "Rojo (malo):"), " 0-49")
    )
  ),

  card(
    card_header("Output Tarjeta de Estadísticas"),
    card_body(statCardOutput("kpi_card", width = "250px"))
  )
)

# Server
server <- function(input, output, session) {
  # Renderizar la tarjeta de estadísticas con estilos condicionales
  output$kpi_card <- renderStatCard({
    value <- input$metric_slider

    status <- case_when(
      value >= 80 ~ "good",
      value >= 50 ~ "warning",
      TRUE ~ "bad"
    )

    list(
      title = "Puntuación de Rendimiento",
      value = value,
      status = status
    )
  })
}

# Ejecutar la app
shinyApp(ui = ui, server = server)
