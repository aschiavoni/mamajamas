Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  initialize: function() {
  },

  events: {
    'click .bt-close': 'close',
  },

  render: function() {
    this.$el.html(this.template({})).show();
    return this;
  },

  close: function() {
    event.preventDefault();
    this.$el.remove();
    return false;
  },

});
