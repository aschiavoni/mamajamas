Mamajamas.Views.ListHelpModals = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/help_modals'],

  initialize: function() {
  },

  events: {
    'click .bt-close': 'close',
    'click .bt-done': 'close',
  },

  render: function() {
    this.$el.html(this.template);
    return this;
  },

  close: function(event) {
    event.preventDefault();
    this.$el.remove();
    return false;
  },

});
