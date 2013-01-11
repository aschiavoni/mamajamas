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

    // user profile
    if ($("#frm-create-profile").length > 0) {
      new Mamajamas.Views.UserProfile({
        el: '#frm-create-profile'
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
