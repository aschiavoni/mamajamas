Mamajamas.Views.ListItemPriority = Mamajamas.Views.ListItemDropdown.extend({

  tagName: "div",

  className: "priorityset",

  template: HandlebarsTemplates['list_items/priority'],

  initialize: function() {},

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop ul li a": "selectPriority",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  selectPriority: function(event) {
    var $target = $(event.currentTarget);
    var $priorityList = $target.parents("ul");
    var priority = parseInt($target.data("priority"));

    this.model.set("priority", priority);
    $priorityList.hide();
    this.render();

    return false;
  },

});
