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

    Mamajamas.Context.Progress = new Mamajamas.Views.Progress();

    // globally wire infield labels
    var $infieldLabelForms = $('form.label-infield');
    if ($infieldLabelForms.length > 0) {
      $("label", $infieldLabelForms).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    }

    // friends list
    if ($('#friendslist').length > 0) {
      new Mamajamas.Views.FriendsList({
        el: '#friendslist'
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
  },
  Utils: {
    // http://stackoverflow.com/a/7124052/31344
    htmlEscape: function(str) {
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;');
    },
    htmlUnescape: function(value){
      return String(value)
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'")
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&amp;/g, '&');
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
