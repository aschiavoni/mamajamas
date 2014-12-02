Mamajamas.Views.ListItemGifted = Backbone.View.extend({

  tagName: "div",

  className: "own",

  template: HandlebarsTemplates['list_items/gifted'],

  initialize: function() {
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

});
