// Input Binding de Tres Estados
// ==============================
// Un input personalizado de Shiny que cicla entre tres estados.
//
// TU TAREA: Completa los métodos marcados con "TU CÓDIGO AQUÍ"
//
// La estructura HTML (generada por R) se ve así:
//
//   <div id="inputId" class="tri-state-input" data-selected="all">
//     <label class="tri-state-label">Mostrar tareas:</label>
//     <div class="tri-state-options">
//       <button class="tri-state-option active" data-value="all">Todas</button>
//       <button class="tri-state-option" data-value="active">Activas</button>
//       <button class="tri-state-option" data-value="completed">Completadas</button>
//     </div>
//   </div>

// Crear un nuevo objeto de input binding
var triStateBinding = new Shiny.InputBinding();

// Extenderlo con nuestra implementación
$.extend(triStateBinding, {

  // =========================================================================
  // MÉTODO REQUERIDO: find(scope)
  // =========================================================================
  // Propósito: Localizar todas las instancias de este tipo de input en el scope dado
  // Parámetro: scope - Usualmente el documento, pero puede ser una sección más pequeña del DOM
  // Retorna: Un objeto jQuery conteniendo todos los elementos coincidentes
  //
  // PISTA: Usa $(scope).find() con un selector de clase CSS
  // El div contenedor tiene la clase "tri-state-input"
  //
  find: function(scope) {
    // TU CÓDIGO AQUÍ
    // Retorna todos los elementos con clase 'tri-state-input'

  },

  // =========================================================================
  // MÉTODO REQUERIDO: getValue(el)
  // =========================================================================
  // Propósito: Extraer y retornar el valor actual para enviar a R
  // Parámetro: el - El elemento DOM (el div contenedor con clase tri-state-input)
  // Retorna: El valor que estará disponible como input$inputId en R
  //
  // PISTA: La selección actual está almacenada en el atributo data-selected
  // Puedes accederla con $(el).data('selected') o $(el).attr('data-selected')
  //
  // IMPORTANTE: ¡DEBES tener una declaración return o el binding falla silenciosamente!
  //
  getValue: function(el) {
    // TU CÓDIGO AQUÍ
    // Retorna el valor seleccionado actual del atributo data-selected

  },

  // =========================================================================
  // MÉTODO REQUERIDO: subscribe(el, callback)
  // =========================================================================
  // Propósito: Configurar escuchadores de eventos para detectar cuándo cambia el valor
  // Parámetros:
  //   el - El elemento DOM
  //   callback - Función a llamar cuando el valor cambia (notifica a Shiny)
  //
  // Cuando un usuario hace clic en un botón de opción, necesitas:
  //   1. Obtener el valor del atributo data-value del botón clickeado
  //   2. Actualizar el atributo data-selected en el contenedor
  //   3. Actualizar estado visual (remover clase 'active' de todos, agregar al clickeado)
  //   4. Llamar callback() para notificar a Shiny
  //
  // PISTA: Usa delegación de eventos con $(el).on('click.triStateBinding', '.tri-state-option', ...)
  // El namespace (.triStateBinding) ayuda con la limpieza posterior en unsubscribe
  //
  // IMPORTANTE: También agrega un escuchador para eventos 'change' para que receiveMessage
  // pueda disparar actualizaciones. Usa: $(el).on('change.triStateBinding', function() { callback(); });
  //
  subscribe: function(el, callback) {
    // TU CÓDIGO AQUÍ
    // 1. Adjunta un manejador de clic a los botones de opción
    // 2. Cuando se hace clic:
    //    - Obtén el data-value del botón clickeado
    //    - Actualiza $(el).data('selected', value)
    //    - Remueve la clase 'active' de todas las opciones
    //    - Agrega la clase 'active' a la opción clickeada
    //    - Llama callback() para notificar a Shiny
    // 3. También adjunta un manejador de change para notificar a Shiny cuando receiveMessage dispara

  },

  // =========================================================================
  // MÉTODO DE LIMPIEZA: unsubscribe(el)
  // =========================================================================
  // Propósito: Remover manejadores de eventos cuando el elemento se remueve del DOM
  // Esto previene fugas de memoria
  //
  // ¡Este ya está hecho para ti!
  //
  unsubscribe: function(el) {
    $(el).off('.triStateBinding');
  },

  // =========================================================================
  // MÉTODO OPCIONAL: setValue(el, value)
  // =========================================================================
  // Propósito: Establecer el valor del input programáticamente
  // Es usado por receiveMessage cuando R llama a updateTriStateInput()
  //
  // Parámetros:
  //   el - El elemento DOM
  //   value - El nuevo valor a establecer
  //
  // PISTA: Similar a lo que haces en subscribe, pero sin el evento click
  //
  setValue: function(el, value) {
    // TU CÓDIGO AQUÍ
    // 1. Actualiza $(el).data('selected', value)
    // 2. Actualiza el atributo data-selected: $(el).attr('data-selected', value)
    // 3. Remueve la clase 'active' de todas las opciones
    // 4. Agrega la clase 'active' a la opción con data-value coincidente

  },

  // =========================================================================
  // MÉTODO OPCIONAL: receiveMessage(el, data)
  // =========================================================================
  // Propósito: Manejar mensajes enviados desde R vía session$sendInputMessage()
  // Es llamado cuando R ejecuta updateTriStateInput()
  //
  // Parámetros:
  //   el - El elemento DOM
  //   data - Objeto enviado desde R (contiene propiedad 'selected')
  //
  receiveMessage: function(el, data) {
    // TU CÓDIGO AQUÍ
    // 1. Verifica si data tiene una propiedad 'selected'
    // 2. Si la tiene, llama this.setValue(el, data.selected)
    // 3. Dispara un evento change: $(el).trigger('change')

  },

  // =========================================================================
  // MÉTODO OPCIONAL: getRatePolicy()
  // =========================================================================
  // Propósito: Controlar qué tan frecuentemente se envían actualizaciones a R
  // Retorna: Objeto con propiedades 'policy' y 'delay'
  //
  // Políticas:
  //   'direct' - Enviar inmediatamente (sin límite de frecuencia)
  //   'debounce' - Esperar hasta que no haya nuevos valores por 'delay' ms (bueno para escritura)
  //   'throttle' - Enviar como máximo una vez cada 'delay' ms (bueno para sliders)
  //
  // ¡Este ya está hecho para ti!
  //
  getRatePolicy: function() {
    return { policy: 'debounce', delay: 250 };
  }

});

// Registrar el binding con Shiny
// El segundo argumento es un identificador único (usualmente paquete.nombreBinding)
Shiny.inputBindings.register(triStateBinding, 'workshop.triStateInput');
