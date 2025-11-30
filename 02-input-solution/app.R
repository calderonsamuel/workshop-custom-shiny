# Ejercicio 1: Input Binding Personalizado - SOLUCIÓN
# ====================================================

library(shiny)
library(bslib)
library(dplyr)

# Cargar nuestro componente personalizado
source("R/triStateInput.R")

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
ui <- page_sidebar(
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  title = "Ejercicio 1: Input Toggle Tri-Estado (Solución)",

  sidebar = sidebar(
    title = "¡Esta es la solución funcionando!",
    hr(),
    triStateInput(
      inputId = "task_filter",
      label = "Filtrar tareas:",
      choices = c("Todas" = "all", "Activas" = "activa", "Completadas" = "completada"),
      selected = "all"
    ),
    hr(),
    h6("Valor actual desde R:"),
    verbatimTextOutput("filter_value"),
    hr(),
    actionButton("reset_filter", "Restablecer a 'Todas'", class = "btn-secondary")
  ),

  card(
    card_header("Tareas Filtradas"),
    card_body(tableOutput("task_table"))
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
}

# Ejecutar la app
shinyApp(ui = ui, server = server)
