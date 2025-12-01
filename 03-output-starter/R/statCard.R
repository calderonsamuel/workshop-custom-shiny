# Componente Output de Tarjeta de Estadísticas
# Una tarjeta de métricas con estilos condicionales
#
# Este archivo está COMPLETO - no necesitas modificarlo.
# Enfócate en completar el binding de JavaScript en www/js/statcard.js

#' Crear dependencia de tarjeta de estadísticas (solo CSS)
#' @keywords internal
statCardDependency <- function() {
  htmltools::htmlDependency(
    name = "statcard-css",
    version = "1.0.0",
    src = c(file = normalizePath("www")),
    stylesheet = "css/statcard.css"
  )
}

#' Crear dependencia de JavaScript para binding reactivo
#' @keywords internal
statCardJsDependency <- function() {
  htmltools::htmlDependency(
    name = "statcard-js",
    version = "1.0.0",
    src = c(file = normalizePath("www")),
    script = "js/statcard.js"
  )
}

#' Crear una tarjeta de estadísticas
#'
#' @param title El título de la tarjeta
#' @param value El valor a mostrar
#' @param status El estado de la tarjeta: "good", "warning", o "bad"
#' @param width El ancho de la tarjeta (valor CSS)
#' @param id Opcional: ID para usar como output reactivo
#'
#' @return Una tarjeta de estadísticas
#' @export
statCard <- function(title, value, status = NULL, width = "200px", id = NULL) {
  status_class <- if (!is.null(status)) paste0(" status-", status) else ""

  htmltools::tagList(
    statCardDependency(),
    htmltools::tags$div(
      id = id,
      class = paste0("stat-card", status_class),
      style = paste0("width: ", width, ";"),
      htmltools::tags$div(class = "stat-title", title),
      htmltools::tags$div(class = "stat-value", value)
    )
  )
}

#' Crear un placeholder de output para tarjeta de estadísticas
#'
#' @param outputId El nombre del slot de output
#' @param width El ancho de la tarjeta (valor CSS)
#'
#' @return Un contenedor de output para tarjeta de estadísticas
#' @export
statCardOutput <- function(outputId, width = "200px") {
  htmltools::tagList(
    statCardJsDependency(),
    statCard(
      title = "Cargando...",
      value = "--",
      width = width,
      id = outputId
    )
  )
}

#' Renderizar una tarjeta de estadísticas
#'
#' @param expr Una expresión que retorna una lista con title, value, y status
#'
#' @return Una función render para usar con statCardOutput
#' @export
renderStatCard <- function(expr) {
  # Patrón moderno: capturar expresión como quosure y convertir a función
  func <- shiny::quoToFunction(rlang::enquo0(expr))

  # Usar createRenderFunction para integración apropiada con Shiny
  shiny::createRenderFunction(
    func,
    transform = function(value, session, name, ...) {
      # Asegurar que retornamos la estructura esperada
      list(
        title = value$title,
        value = value$value,
        status = value$status
      )
    },
    outputFunc = statCardOutput
  )
}
