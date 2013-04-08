Mamajamas.Views.ListItemAgeRange = Mamajamas.Views.ListItemDropdown.extend({

  tagName: 'td',

  className: "when",

  template: HandlebarsTemplates['list_items/age_range'],

  initialize: function() {},

  events: {
    "click .prod-drop .prod-drop-arrow": "toggleAgeRangeList",
    "click .when-txt": "toggleAgeRangeList",
    "click .prod-drop ul li a": "selectAgeRange",
    "mouseenter .when-txt": "showArrow",
    "mouseleave": "hideArrow",
    "mouseleave .prod-drop-arrow": "hideArrow"
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  toggleAgeRangeList: function(event) {
    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      var $target = $(event.target);
      var $prodDrop = $target.parents("td").find(".prod-drop");
      var $ageRangeList = $prodDrop.find("ul");

      if ($ageRangeList.hasClass("visuallyhidden")) {
        $ageRangeList.removeClass("visuallyhidden");
      } else {
        $ageRangeList.addClass("visuallyhidden");
      }
    }

    return false;
  },

  selectAgeRange: function(event) {
    var $target = $(event.target);
    var $ageRangeList = $target.parents("ul");
    var ageRange = $target.html();

    this.model.set("age", ageRange);
    $ageRangeList.addClass("visuallyhidden");
    this.render();

    return false;
  }

});
