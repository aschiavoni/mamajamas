Mamajamas.Views.ListItem = Mamajamas.Views.Base.extend({

  setCurrentPosition: function() {
    var $priorityContainer = this.$el.parents("div.collapsible-content");
    var curPos = $("div.prod", $priorityContainer).index(this.$el);
    Mamajamas.Context.List.set("current_position", curPos);
  },

  doNothing: function(event) {
    event.preventDefault();
    return false;
  },

});
