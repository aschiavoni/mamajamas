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

  appendItem: function(listItem) {
    var view = new Mamajamas.Views.ListItemShow({
      model: listItem
    });
    $("#list-items").append(view.render().$el);
  }
});
