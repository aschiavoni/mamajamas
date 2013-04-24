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

    // globally wire infield labels
    var $infieldLabelForms = $('form.label-infield');
    if ($infieldLabelForms.length > 0) {
      $("label", $infieldLabelForms).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    }

    // follow page
    if ($('#follow-moms').length > 0) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }

    // user profile
    if ($('#frm-create-profile').length > 0) {
      new Mamajamas.Views.UserProfile({
        el: '#frm-create-profile'
      });
    }

    // list
    if ($('#my-list').length > 0) {
      new Mamajamas.Routers.ListItems();
      Backbone.history.start();
    }

    // public list
    if ($('#publist').length > 0) {
      new Mamajamas.Routers.PublicListItems();
      Backbone.history.start();
    }

    // quiz
    if ($('#quiz').length > 0) {
      new Mamajamas.Routers.Quiz();
      Backbone.history.start();
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
