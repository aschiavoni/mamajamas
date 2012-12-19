Mamajamas.Views.ListItemPriority = Mamajamas.Views.ListItemDropdown.extend({

  tagName: 'td',

  className: "priority",

  template: HandlebarsTemplates['list_items/priority'],

  initialize: function() {},

  events: {
    "click .prod-drop .prod-drop-arrow": "togglePriorityList",
    "click .priority-display": "togglePriorityList",
    "click .prod-drop ul li a": "selectPriority",
    "mouseenter .priority-display": "showArrow",
    "mouseleave": "hideArrow",
    "mouseleave .prod-drop-arrow": "hideArrow",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  togglePriorityList: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.parents("td").find(".prod-drop");
    var $priorityList = $prodDrop.find("ul");

    if ($priorityList.hasClass("visuallyhidden")) {
      $priorityList.removeClass("visuallyhidden");
    } else {
      $priorityList.addClass("visuallyhidden");
    }

    return false;
  },

  selectPriority: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.parents(".prod-drop");
    var priorityClass = $target.parents("li").attr("class");

    var newPriority = 3;
    switch(priorityClass) {
      case "priority-low":
        newPriority = 3;
        break;
      case "priority-med":
        newPriority = 2;
        break;
      case "priority-high":
        newPriority = 1;
        break;
    }

    this.model.set("priority", newPriority);
    $prodDrop.addClass("hidden");
    this.render();

    return false;
  }

});

