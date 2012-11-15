Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  initialize: function() {
    this.$el.addClass("prod").addClass("prod-filled");
  },

  events: {
  },

  render: function(event) {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  }
});

