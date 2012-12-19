Mamajamas.Views.ListItemWhenToBuy = Mamajamas.Views.ListItemDropdown.extend({

  tagName: 'td',

  className: "when",

  template: HandlebarsTemplates['list_items/when_to_buy'],

  initialize: function() {},

  events: {
    "click .prod-drop .prod-drop-arrow": "toggleWhenToBuyList",
    "click .when-txt": "toggleWhenToBuyList",
    "click .prod-drop ul li a": "selectWhenToBuy",
    "mouseenter .when-txt": "showArrow",
    "mouseleave": "hideArrow",
    "mouseleave .prod-drop-arrow": "hideArrow"
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  toggleWhenToBuyList: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.parents("td").find(".prod-drop");
    var $whenList = $prodDrop.find("ul");

    if ($whenList.hasClass("visuallyhidden")) {
      $whenList.removeClass("visuallyhidden");
    } else {
      $whenList.addClass("visuallyhidden");
    }

    return false;
  },

  selectWhenToBuy: function(event) {
    var $target = $(event.target);
    var $whenList = $target.parents("ul");
    var whenToBuy = $target.html();

    this.model.set("when_to_buy", whenToBuy);
    $whenList.addClass("visuallyhidden");

    return false;
  }

});
