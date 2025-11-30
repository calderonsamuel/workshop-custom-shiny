// Stat Card Output Binding - SOLUTION
// ====================================
// A custom Shiny output that displays metrics with conditional styling.

var statCardBinding = new Shiny.OutputBinding();

$.extend(statCardBinding, {

  // Find all instances of this output in the given scope
  find: function(scope) {
    return $(scope).find('.stat-card');
  },

  // Render the value received from R
  renderValue: function(el, data) {
    // Handle null data
    if (data === null) {
      $(el).find('.stat-title').text('No data');
      $(el).find('.stat-value').text('--');
      $(el).removeClass('status-good status-warning status-bad');
      return;
    }

    // Set the title and value text
    $(el).find('.stat-title').text(data.title);
    $(el).find('.stat-value').text(data.value);

    // Remove any existing status class and add the new one
    $(el).removeClass('status-good status-warning status-bad');
    if (data.status) {
      $(el).addClass('status-' + data.status);
    }
  },

  // Handle errors from R
  renderError: function(el, error) {
    $(el).find('.stat-title').text('Error');
    $(el).find('.stat-value').text(error.message);
    $(el).removeClass('status-good status-warning status-bad');
    $(el).addClass('status-bad');
  },

  // Clear error state
  clearError: function(el) {
    $(el).removeClass('status-bad');
  }

});

// Register the binding with Shiny
Shiny.outputBindings.register(statCardBinding, 'workshop.statCardOutput');
