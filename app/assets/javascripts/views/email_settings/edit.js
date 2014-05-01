Mamajamas.Views.EmailSettings = Backbone.View.extend({

  initialize: function() {
  },

  events: {
    'change #settings_unsubscribe_all': 'toggleUnsubscribeAll'
  },

  toggleUnsubscribeAll: function(event) {
    var $cb = $(event.currentTarget);
    if ($cb.prop('checked')) {
      $('#ind-emails').slideUp();
    } else {
      $('#ind-emails').slideDown();
    }
  },

});
