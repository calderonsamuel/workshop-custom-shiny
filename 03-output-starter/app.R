# Ejercicio 2: Output Binding Personalizado - Tarjeta de Estadísticas
# ====================================================================
#
# TU TAREA: Completa el binding de JavaScript en www/js/statcard.js
#
# ¡Esta app no funcionará hasta que implementes los métodos del binding!
# Abre www/js/statcard.js y sigue las instrucciones allí.

library(shiny)
library(bslib)
library(dplyr)

# Cargar nuestro componente personalizado
source("R/statCard.R")

# UI
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Ejercicio 2: Output Tarjeta de Estadísticas",

  sidebar = sidebar(
    title = "Instrucciones",
    p("Completa el binding de JavaScript en", code("www/js/statcard.js")),
    p("Cuando funcione, la tarjeta debería:"),
    tags$ul(
      tags$li("Mostrar el título y el valor"),
      tags$li("Cambiar de color según el umbral de puntuación")
    ),
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
  ),

  card(
    card_header("Lista de Progreso"),
    card_body(
      class = "bg-light",
      tags$p(tags$strong("Después de implementar find():")),
      tags$ul(
        tags$li("Sin errores de JavaScript en la consola")
      ),
      tags$p(tags$strong("Después de implementar renderValue():")),
      tags$ul(
        tags$li("La tarjeta muestra el título y el valor"),
        tags$li("Al mover el slider se actualiza la tarjeta"),
        tags$li("El color de la tarjeta cambia según los umbrales")
      )
    )
  ),

  card(
    card_header("Debug: Datos enviados a JavaScript"),
    card_body(verbatimTextOutput("debug_output"))
  )
)

# Server
server <- function(input, output, session) {
  # Calcular los datos de la tarjeta de forma reactiva
  card_data <- reactive({
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

  # Renderizar la tarjeta de estadísticas
  output$kpi_card <- renderStatCard({
    card_data()
  })

  # Output de debug para mostrar qué datos se están enviando
  output$debug_output <- renderPrint({
    card_data()
  })
}

# Ejecutar la app
shinyApp(ui = ui, server = server)
