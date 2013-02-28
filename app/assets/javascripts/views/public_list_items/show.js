Mamajamas.Views.PublicListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['public_list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    'click input.prod-owned': 'doNothing'
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model,
    });
    ratingView.readOnly = true;
    $("td.rating", this.$el).append(ratingView.render().$el);

    return this;
  },

  doNothing: function() {
    return false;
  },

});
