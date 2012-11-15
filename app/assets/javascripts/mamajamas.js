window.Mamajamas = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Context: {},
  initialize: function() {
    if ($("#follow-moms").length > 0) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }

    if ($("#my-list").length > 0) {
      new Mamajamas.Routers.ListItems();
      Backbone.history.start();
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
