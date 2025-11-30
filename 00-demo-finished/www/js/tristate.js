// Tri-State Input Binding
// A custom Shiny input that cycles through three states

var triStateBinding = new Shiny.InputBinding();

$.extend(triStateBinding, {
  // Find all instances of this input in the given scope
  find: function(scope) {
    return $(scope).find('.tri-state-input');
  },

  // Get the current value to send to R
  getValue: function(el) {
    return $(el).data('selected');
  },

  // Set the value programmatically
  setValue: function(el, value) {
    $(el).data('selected', value);
    $(el).attr('data-selected', value);
    // Update visual state
    $(el).find('.tri-state-option').removeClass('active');
    $(el).find('.tri-state-option[data-value="' + value + '"]').addClass('active');
  },

  // Subscribe to events that should trigger an update
  subscribe: function(el, callback) {
    $(el).on('click.triStateBinding', '.tri-state-option', function(e) {
      var value = $(this).data('value');
      $(el).data('selected', value);
      $(el).attr('data-selected', value);
      // Update visual state
      $(el).find('.tri-state-option').removeClass('active');
      $(this).addClass('active');
      callback();
    });
    // Also listen for change events (triggered by receiveMessage)
    $(el).on('change.triStateBinding', function(e) {
      callback();
    });
  },

  // Clean up event handlers
  unsubscribe: function(el) {
    $(el).off('.triStateBinding');
  },

  // Receive messages from R (for updateTriStateInput)
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('selected')) {
      this.setValue(el, data.selected);
      $(el).trigger('change');
    }
  },

  // Rate limit updates (optional - debounce rapid clicks)
  getRatePolicy: function() {
    return { policy: 'debounce', delay: 250 };
  }
});

// Register the binding with Shiny
Shiny.inputBindings.register(triStateBinding, 'workshop.triStateInput');
