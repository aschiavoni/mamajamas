Mamajamas.Views.ListItemAgeRange = Mamajamas.Views.ListItemDropdown.extend({

  tagName: "div",

  className: "when",

  template: HandlebarsTemplates['list_items/age_range'],

  initialize: function() {},

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop ul li a": "selectAgeRange",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  selectAgeRange: function(event) {
    var $target = $(event.currentTarget);
    var $ageRangeList = $target.parents("ul");
    var ageRange = $target.html();

    this.model.set("age", ageRange);
    $ageRangeList.hide();
    this.render();

    return false;
  }

});
