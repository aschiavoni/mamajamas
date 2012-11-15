window.Mamajamas = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Context: {},
  initialize: function() {
    if ($("#follow-moms")) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }

    if ($("#my-list")) {
      new Mamajamas.Routers.ListItems();
      Backbone.history.start();
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
