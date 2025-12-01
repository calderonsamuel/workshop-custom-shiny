// Input Binding de Tres Estados
// Un input personalizado de Shiny que cicla entre tres estados

var triStateBinding = new Shiny.InputBinding();

$.extend(triStateBinding, {
  // Encontrar todas las instancias de este input en el scope dado
  find: function(scope) {
    return $(scope).find('.tri-state-input');
  },

  // Obtener el valor actual para enviar a R
  getValue: function(el) {
    return $(el).data('selected');
  },

  // Establecer el valor programáticamente
  setValue: function(el, value) {
    $(el).data('selected', value);
    $(el).attr('data-selected', value);
    // Actualizar estado visual
    $(el).find('.tri-state-option').removeClass('active');
    $(el).find('.tri-state-option[data-value="' + value + '"]').addClass('active');
  },

  // Suscribirse a eventos que deben disparar una actualización
  subscribe: function(el, callback) {
    $(el).on('click.triStateBinding', '.tri-state-option', function(e) {
      var value = $(this).data('value');
      $(el).data('selected', value);
      $(el).attr('data-selected', value);
      // Actualizar estado visual
      $(el).find('.tri-state-option').removeClass('active');
      $(this).addClass('active');
      callback();
    });
    // También escuchar eventos change (disparados por receiveMessage)
    $(el).on('change.triStateBinding', function(e) {
      callback();
    });
  },

  // Limpiar manejadores de eventos
  unsubscribe: function(el) {
    $(el).off('.triStateBinding');
  },

  // Recibir mensajes desde R (para updateTriStateInput)
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('selected')) {
      this.setValue(el, data.selected);
      $(el).trigger('change');
    }
  },

  // Limitar la frecuencia de actualizaciones (debounce para clics rápidos)
  getRatePolicy: function() {
    return { policy: 'debounce', delay: 250 };
  }
});

// Registrar el binding con Shiny
Shiny.inputBindings.register(triStateBinding, 'workshop.triStateInput');
