# App Demo: Inputs y Outputs Personalizados de Shiny
# Esta app demuestra tanto el input tri-state toggle como el output stat card

library(shiny)
library(bslib)
library(dplyr)

# Cargar nuestros componentes personalizados
source("R/triStateInput.R")
source("R/statCard.R")

# Datos de ejemplo para la demo
tareas <- data.frame(
  id = 1:10,
  tarea = c(
    "Revisar pull request",
    "Escribir documentación",
    "Corregir bug de login",
    "Actualizar dependencias",
    "Diseñar nueva funcionalidad",
    "Revisión de código",
    "Desplegar a staging",
    "Escribir tests unitarios",
    "Refactorizar API",
    "Actualizar README"
  ),
  estado = c(
    "completada", "activa", "activa", "completada", "activa",
    "completada", "completada", "activa", "completada", "activa"
  ),
  stringsAsFactors = FALSE
)

# UI
ui <- page_fluid(
  theme = bs_theme(version = 5, bootswatch = "flatly"),

  h2("Demo de Bindings Personalizados en Shiny"),

  layout_columns(
    col_widths = c(6, 6),

    card(
      card_header("Input Personalizado: Toggle Tri-Estado"),
      card_body(
        p("Haz clic en los botones para filtrar tareas por estado."),

        triStateInput(
          inputId = "task_filter",
          label = "Mostrar tareas:",
          choices = c("Todas" = "all", "Activas" = "activa", "Completadas" = "completada"),
          selected = "all"
        ),

        hr(),

        h5("Tareas Filtradas:"),
        tableOutput("task_table"),

        hr(),

        h5("Valor actual del filtro (desde R):"),
        verbatimTextOutput("filter_value"),

        actionButton("reset_filter", "Restablecer a 'Todas'", class = "btn-secondary")
      )
    ),

    card(
      card_header("Output Personalizado: Tarjeta de Estadísticas"),
      card_body(
        p("Mueve el slider para ver cómo cambia el color de la tarjeta según los umbrales."),

        sliderInput(
          inputId = "metric_slider",
          label = "Puntuación de Rendimiento:",
          min = 0,
          max = 100,
          value = 75
        ),

        statCardOutput("kpi_card", width = "250px"),

        hr(),

        h5("Umbrales:"),
        tags$ul(
          tags$li(tags$span(class = "text-success", "Verde (Bueno):"), " 80-100"),
          tags$li(tags$span(class = "text-warning", "Amarillo (Advertencia):"), " 50-79"),
          tags$li(tags$span(class = "text-danger", "Rojo (Malo):"), " 0-49")
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  # Filtrar tareas según el input tri-state

filtered_tasks <- reactive({
    filter_val <- input$task_filter

    if (is.null(filter_val) || filter_val == "all") {
      tareas
    } else {
      tareas %>% filter(estado == filter_val)
    }
  })

  # Renderizar la tabla de tareas filtradas
  output$task_table <- renderTable({
    filtered_tasks() %>%
      select(Tarea = tarea, Estado = estado)
  })

  # Mostrar el valor actual del filtro
  output$filter_value <- renderPrint({
    input$task_filter
  })

  # Manejador del botón de restablecer
  observeEvent(input$reset_filter, {
    updateTriStateInput(session, "task_filter", "all")
  })

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
