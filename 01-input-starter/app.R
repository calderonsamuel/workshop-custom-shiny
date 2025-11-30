# Ejercicio 1: Input Binding Personalizado - Toggle Tri-Estado
# =============================================================
#
# TU TAREA: Completa el binding de JavaScript en www/js/tristate.js
#
# ¡Esta app no funcionará hasta que implementes los métodos del binding!
# Abre www/js/tristate.js y sigue las instrucciones allí.

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
  title = "Ejercicio 1: Input Toggle Tri-Estado",

  sidebar = sidebar(
    title = "Instrucciones",
    p("Completa el binding de JavaScript en", code("www/js/tristate.js")),
    p("Cuando funcione, el toggle debería:"),
    tags$ul(
      tags$li("Actualizarse al hacer clic en cada opción"),
      tags$li("Filtrar la tabla de tareas"),
      tags$li("Mostrar el valor actual en el cuadro de debug")
    ),
    hr(),
    triStateInput(
      inputId = "task_filter",
      label = "Filtrar tareas:",
      choices = c("Todas" = "all", "Activas" = "activa", "Completadas" = "completada"),
      selected = "all"
    ),
    hr(),
    h6("Debug: Valor actual desde R"),
    verbatimTextOutput("filter_value"),
    hr(),
    actionButton("reset_filter", "Restablecer a 'Todas'", class = "btn-secondary"),
    p(class = "text-muted mt-2", "Este botón prueba updateTriStateInput()")
  ),

  card(
    card_header("Tareas Filtradas"),
    card_body(tableOutput("task_table"))
  ),

  card(
    card_header("Lista de Progreso"),
    card_body(
      class = "bg-light",
      tags$p(tags$strong("Después de implementar find() y getValue():")),
      tags$ul(
        tags$li("El cuadro 'Valor actual' debería mostrar 'all' (no NULL)")
      ),
      tags$p(tags$strong("Después de implementar subscribe():")),
      tags$ul(
        tags$li("Al hacer clic en las opciones debería actualizar el valor y filtrar la tabla")
      ),
      tags$p(tags$strong("Después de implementar setValue() y receiveMessage():")),
      tags$ul(
        tags$li("El botón 'Restablecer a Todas' debería funcionar")
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

  # Mostrar el valor actual del filtro (para debugging)
  output$filter_value <- renderPrint({
    input$task_filter
  })

  # Manejador del botón de restablecer - prueba updateTriStateInput
  observeEvent(input$reset_filter, {
    updateTriStateInput(session, "task_filter", "all")
  })
}

# Ejecutar la app
shinyApp(ui = ui, server = server)
