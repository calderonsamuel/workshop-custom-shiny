// Output Binding de Tarjeta de Estadísticas
// ==========================================
// Un output personalizado de Shiny que muestra métricas con estilos condicionales.
//
// TU TAREA: Completa los métodos marcados con "TU CÓDIGO AQUÍ"
//
// ¡Los output bindings son más simples que los input bindings!
// Solo necesitas implementar dos métodos: find() y renderValue()
//
// La estructura HTML (generada por R) se ve así:
//
//   <div id="outputId" class="stat-card" style="width: 200px;">
//     <div class="stat-title">Cargando...</div>
//     <div class="stat-value">--</div>
//   </div>
//
// Los datos enviados desde R (vía renderStatCard) se ven así:
//   { title: "Puntuación de Rendimiento", value: 75, status: "warning" }
//
// Status puede ser: "good", "warning", o "bad"
// Estos corresponden a clases CSS: status-good, status-warning, status-bad

// Crear un nuevo objeto de output binding
var statCardBinding = new Shiny.OutputBinding();

// Extenderlo con nuestra implementación
$.extend(statCardBinding, {

  // =========================================================================
  // MÉTODO REQUERIDO: find(scope)
  // =========================================================================
  // Propósito: Localizar todas las instancias de este tipo de output en el scope dado
  // Parámetro: scope - Usualmente el documento, pero puede ser una sección más pequeña del DOM
  // Retorna: Un objeto jQuery conteniendo todos los elementos coincidentes
  //
  // PISTA: Usa $(scope).find() con un selector de clase CSS
  // El div contenedor tiene la clase "stat-card"
  //
  find: function(scope) {
    // TU CÓDIGO AQUÍ
    // Retorna todos los elementos con clase 'stat-card'

  },

  // =========================================================================
  // MÉTODO REQUERIDO: renderValue(el, data)
  // =========================================================================
  // Propósito: Actualizar el elemento DOM con los datos recibidos desde R
  // Parámetros:
  //   el - El elemento DOM (el div contenedor con clase stat-card)
  //   data - Objeto enviado desde R conteniendo: { title, value, status }
  //
  // Necesitas:
  //   1. Manejar el caso donde data es null (aún no hay datos)
  //   2. Actualizar el elemento .stat-title con data.title
  //   3. Actualizar el elemento .stat-value con data.value
  //   4. Remover cualquier clase de estado existente (status-good, status-warning, status-bad)
  //   5. Agregar la clase de estado apropiada basada en data.status
  //
  // PISTAS:
  //   - Usa $(el).find('.stat-title').text(data.title) para establecer texto
  //   - Usa $(el).removeClass('status-good status-warning status-bad') para limpiar
  //   - Usa $(el).addClass('status-' + data.status) para agregar la nueva clase
  //
  renderValue: function(el, data) {
    // TU CÓDIGO AQUÍ

    // Paso 1: Manejar datos null
    // if (data === null) {
    //   ... establece title a 'Sin datos', value a '--', remueve clases de estado
    //   return;
    // }

    // Paso 2: Establecer el texto del título

    // Paso 3: Establecer el texto del valor

    // Paso 4: Remover todas las clases de estado

    // Paso 5: Agregar la nueva clase de estado (si data.status existe)

  },

  // =========================================================================
  // MÉTODO OPCIONAL: renderError(el, error)
  // =========================================================================
  // Propósito: Mostrar un mensaje de error cuando R lanza un error
  // ¡Este ya está hecho para ti!
  //
  renderError: function(el, error) {
    $(el).find('.stat-title').text('Error');
    $(el).find('.stat-value').text(error.message);
    $(el).removeClass('status-good status-warning status-bad');
    $(el).addClass('status-bad');
  },

  // =========================================================================
  // MÉTODO OPCIONAL: clearError(el)
  // =========================================================================
  // Propósito: Limpiar el estado de error cuando el renderizado tiene éxito de nuevo
  // ¡Este ya está hecho para ti!
  //
  clearError: function(el) {
    $(el).removeClass('status-bad');
  }

});

// Registrar el binding con Shiny
// El segundo argumento es un identificador único (usualmente paquete.nombreBinding)
Shiny.outputBindings.register(statCardBinding, 'workshop.statCardOutput');
