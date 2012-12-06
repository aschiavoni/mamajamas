Mamajamas.Views.ListItemsIndex = Backbone.View.extend({

  template: HandlebarsTemplates['list_items/index'],

  initialize: function() {
    this.collection.on("reset", this.render, this);
    this.collection.on("add", this.insertItem, this);
    this.collection.on("remove", this.removeItem, this);
  },

  events: {
    "click #babygear th.item": "sort",
    "click #babygear th.when": "sort",
    "click #babygear th.priority": "sort"
  },

  render: function() {
    this.collection.each(this.appendItem, this);
    return this;
  },

  insertItem: function(item) {
    $("#list-items").prepend(this.itemView(item).render().$el);
  },

  appendItem: function(item) {
    var $itemView = this.itemView(item).render().$el;
    $("#list-items").append($itemView);
  },

  removeItem: function(item, items, options) {
    var $listItem = $("#list-item-" + item.get("id"), "#list-items");
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
      })
    }
    return view;
  }
});
