Mamajamas.Views.PublicListItemShow = Backbone.View.extend({

  tagName: "div",

  template: HandlebarsTemplates["public_list_items/show"],

  className: "prod prod-filled clearfix",

  initialize: function() {
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    'click .bt-add': 'addToMyList',
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model,
    });
    ratingView.readOnly = true;
    $("div.rating", this.$el).append(ratingView.render().$el);

    return this;
  },

  addToMyList: function(event) {
    $.cookies.set("add_to_my_list", this.model.id);
    return true;
  },

});
