Mamajamas.Views.ListItemDropdown = Backbone.View.extend({

  showArrow: function(event) {
    var $td = $(event.target);
    if (!$td.is('td'))
      $td = $(event.target).parents("td");

    // check if the prod-drop is already open
    // if it is do nothing
    if ($td.find(".prod-drop ul").hasClass("visuallyhidden")) {
      var $arrow = $td.find(".prod-drop .prod-drop-arrow");
      $arrow.show();
    }
  },

  hideArrow: function(event) {
    var $td = $(event.target);
    if (!$td.is('td'))
      $td = $(event.target).parents("td");

    if ($td.find(".prod-drop ul").hasClass("visuallyhidden")) {
      var $arrow = $td.find(".prod-drop .prod-drop-arrow");
      $arrow.hide();
    }
  }

});
