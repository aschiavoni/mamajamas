Mamajamas.Views.ListItemsIndex = Backbone.View.extend({

  template: HandlebarsTemplates['list_items/index'],

  tagName: "tbody",

  initialize: function() {
    this.collection.on("reset", this.render, this);
    this.collection.on("add", this.insertItem, this);
    this.collection.on("remove", this.removeItem, this);

    this.$el.attr("id", "list-items");
  },

  render: function() {
    this.$el.html(this.template);
    this.collection.each(this.appendItem, this);
    return this;
  },

  insertItem: function(item, collection, options) {
    var insertAt = Mamajamas.Context.List.get("current_position");
    if (insertAt == 0) {
      $("#list-items").prepend(this.itemView(item).render().$el);
    } else {
      $("#list-items tr:nth-child(" + insertAt + ")").after(this.itemView(item).render().$el);
    }
  },

  appendItem: function(item) {
    var $itemView = this.itemView(item).render().$el;
    $("#list-items").append($itemView);
  },

  removeItem: function(item, items, options) {
    var $listItem = $("#" + item.get("id"), "#list-items");
    if ($listItem) {
      $listItem.remove();
    }
  },

  sort: function(event) {
    var $target = $(event.target);
    var sortBy = $target.data("sort");
    this.collection.changeSort(sortBy);
    this.collection.sort();
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
      });
    }
    return view;
  }

});
