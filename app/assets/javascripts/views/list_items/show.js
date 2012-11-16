Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
  },

  events: {
  },

  render: function(event) {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  }
});

