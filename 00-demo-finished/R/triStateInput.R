# Tri-State Input Component
# A toggle button that cycles through three states

#' Create a tri-state input dependency
#' @keywords internal
triStateDependency <- function() {
 htmltools::htmlDependency(
   name = "tristate",
   version = "1.0.0",
   src = c(file = normalizePath("www")),
   script = "js/tristate.js",
   stylesheet = "css/tristate.css"
 )
}

#' Create a tri-state toggle input
#'
#' @param inputId The input slot that will be used to access the value
#' @param label Display label for the control
#' @param choices A named vector of choices. Names are displayed, values are returned
#' @param selected The initially selected value (defaults to first choice)
#'
#' @return A tri-state input control
#' @export
triStateInput <- function(inputId, label, choices, selected = NULL) {
 if (is.null(selected)) {
   selected <- choices[1]
 }

 # Build the option buttons
 options <- lapply(seq_along(choices), function(i) {
   value <- choices[i]
   name <- if (!is.null(names(choices))) names(choices)[i] else value
   is_active <- value == selected

   htmltools::tags$button(
     type = "button",
     class = paste("tri-state-option", if (is_active) "active" else ""),
     `data-value` = value,
     name
   )
 })

 htmltools::tagList(
   triStateDependency(),
   htmltools::tags$div(
     id = inputId,
     class = "tri-state-input",
     `data-selected` = selected,
     htmltools::tags$label(class = "tri-state-label", label),
     htmltools::tags$div(
       class = "tri-state-options",
       options
     )
   )
 )
}

#' Update a tri-state input on the client
#'
#' @param session The session object passed to the Shiny server function
#' @param inputId The id of the input to update
#' @param selected The new selected value
#'
#' @export
updateTriStateInput <- function(session, inputId, selected) {
 session$sendInputMessage(inputId, list(selected = selected))
}
