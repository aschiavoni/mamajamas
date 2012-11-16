Mamajamas.Views.ListItemsIndex = Backbone.View.extend({

  template: HandlebarsTemplates['list_items/index'],

  initialize: function() {
    _index = this;
    this.collection.on("reset", this.render, this);
    this.collection.on("add", this.insertItem, this);
  },

  render: function() {
    this.$el.html(this.template);
    this.collection.each(this.appendItem);
    return this;
  },

  insertItem: function(item) {
    $("#list-items").prepend(_index.itemView(item).render().$el);
  },

  appendItem: function(item) {
    $("#list-items").append(_index.itemView(item).render().$el);
  },

  itemView: function(item) {
    var view = null;
    if (item.get('type') == "ListItem") {
      // ListItem
       view = new Mamajamas.Views.ListItemShow({
        model: item
      });
    } else {
      // ProductType
      view = new Mamajamas.Views.ProductTypeShow({
        model: item
      })
    }
    return view;
  }
});
