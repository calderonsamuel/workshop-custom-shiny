// Output Binding de Tarjeta de Estadísticas - SOLUCIÓN
// =====================================================
// Un output personalizado de Shiny que muestra métricas con estilos condicionales.

var statCardBinding = new Shiny.OutputBinding();

$.extend(statCardBinding, {

  // Encontrar todas las instancias de este output en el scope dado
  find: function(scope) {
    return $(scope).find('.stat-card');
  },

  // Renderizar el valor recibido desde R
  renderValue: function(el, data) {
    // Manejar datos null
    if (data === null) {
      $(el).find('.stat-title').text('Sin datos');
      $(el).find('.stat-value').text('--');
      $(el).removeClass('status-good status-warning status-bad');
      return;
    }

    // Establecer el texto del título y valor
    $(el).find('.stat-title').text(data.title);
    $(el).find('.stat-value').text(data.value);

    // Remover cualquier clase de estado existente y agregar la nueva
    $(el).removeClass('status-good status-warning status-bad');
    if (data.status) {
      $(el).addClass('status-' + data.status);
    }
  },

  // Manejar errores desde R
  renderError: function(el, error) {
    $(el).find('.stat-title').text('Error');
    $(el).find('.stat-value').text(error.message);
    $(el).removeClass('status-good status-warning status-bad');
    $(el).addClass('status-bad');
  },

  // Limpiar estado de error
  clearError: function(el) {
    $(el).removeClass('status-bad');
  }

});

// Registrar el binding con Shiny
Shiny.outputBindings.register(statCardBinding, 'workshop.statCardOutput');
