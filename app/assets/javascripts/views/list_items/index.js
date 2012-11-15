Mamajamas.Views.ListItemsIndex = Backbone.View.extend({

  template: HandlebarsTemplates['list_items/index'],

  initialize: function() {
    this.collection.on("reset", this.render, this);
  },

  render: function() {
    this.$el.html(this.template);
    this.collection.each(this.appendItem);
    return this;
  },

  appendItem: function(item) {
    var view = null;
    if (item.get('type') == "ListItem") {
       view = new Mamajamas.Views.ListItemShow({
        model: item
      });
    } else {
      // ProductType
      view = new Mamajamas.Views.ProductTypeShow({
        model: item
      })
    }

    $("#list-items").append(view.render().$el);
  }
});
