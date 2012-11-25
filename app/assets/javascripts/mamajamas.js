window.Mamajamas = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Context: {
  },
  initialize: function() {
    // initialize notifications
    Mamajamas.Context.Notifications = new Mamajamas.Collections.Notifications();
    var notifications = new Mamajamas.Views.NotificationsIndex({
      collection: Mamajamas.Context.Notifications
    });
    notifications.render();

    // follow page
    if ($("#follow-moms").length > 0) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }

    // list
    if ($("#my-list").length > 0) {
      new Mamajamas.Routers.ListItems();
      Backbone.history.start();
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
