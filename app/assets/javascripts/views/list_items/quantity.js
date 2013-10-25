Mamajamas.Views.ListItemQuantity = Mamajamas.Views.ListItemDropdown.extend({

  tagName: "div",

  className: "own",

  template: HandlebarsTemplates["list_items/quantity"],

  initialize: function() {},

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop.have-need ul li a": "selectHaveNeed",
    "click .choicedrop.quantity ul li a": "selectQuantity",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  selectHaveNeed: function(event) {
    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();
    var owned = value === "have";

    this.model.set("owned", owned);
    $list.hide();
    this.render();

    return false;
  },

  selectQuantity: function(event) {
    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();

    this.model.set("quantity", value);
    $list.hide();
    this.render();

    return false;
  },

});
