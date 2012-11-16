Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);
    return this;
  }
});

