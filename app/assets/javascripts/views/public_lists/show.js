Mamajamas.Views.PublicListShow = Backbone.View.extend({

  initialize: function() {
    this.collection.on('reset', this.render, this);
  },

  events: {
    "click #babygear th.own": "sort",
    "click #babygear th.item": "sort",
    "click #babygear th.when": "sort",
    "click #babygear th.rating": "sort",
    "click #babygear th.priority": "sort"
  },

  render: function() {
    $("#list-items").empty();
    this.collection.each(this.appendItem, this);
  },

  appendItem: function(item) {
    var view = new Mamajamas.Views.PublicListItemShow({
      model: item
    });
    $("#list-items").append(view.render().$el);
  },

  sort: function(event) {
    var $header = $(event.target);
    $("#babygear th").removeClass("sorting");
    $header.addClass("sorting");

    var sortBy = $header.data("sort");

    this.collection.changeSort(sortBy);
    this.collection.sort();
  },

});
