Mamajamas.Views.ListItemQuantity = Mamajamas.Views.ListItemDropdown.extend({

  tagName: "div",

  className: "own",

  template: HandlebarsTemplates["list_items/quantity"],

  minimum: 0,

  initialize: function(options) {
    _.extend(this,
             _.pick(options, 'quantityField', 'quantityLabel', 'minimum'));
  },

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop.quantity ul li a": "selectQuantity",
  },

  render: function() {
    this.$el.html(this.template({
      quantity: this.model.get(this.quantityField),
      quantityLabel: this.quantityLabel
    }));

    if (this.minimum > 0) {
      var min = this.minimum;
      $('ul li > a', this.$el).each(function(idx, elem) {
        var $elem = $(elem);
        var n = parseInt($elem.html());
        if (n < min)
          $elem.remove();
      });
    }
    return this;
  },

  selectQuantity: function(event) {
    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();

    this.model.set(this.quantityField, value);
    $list.hide();
    this.render();

    return false;
  },

});
