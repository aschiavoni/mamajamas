window.Mamajamas = {
  Models: {},
  Collections: {},
  Views: { Admin: {} },
  Routers: {},
  Components: {},
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

    $('body').on('click', '.get-bookmark', function(event) {
      event.preventDefault();
      $.modal.close();
      // show the bookmarklet prompt
      var bookmarkletPrompt = new Mamajamas.Views.ListBookmarkletPrompt();
      $('body').append(bookmarkletPrompt.render().$el);
      bookmarkletPrompt.show();
      return false;
    });

    // home page
    if ($("body.home").length > 0) {
      new Mamajamas.Views.HomeIndex();
    }

    // follow page
    if ($('#follow-moms').length > 0) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }

    // friends list
    if ($('#friendslistapp').length > 0) {
      new Mamajamas.Views.FriendsList({
        el: '#friendslistapp'
      });
    }

    // find friends
    if ($('#findfriendsapp').length > 0) {
      Mamajamas.Context.Invites = new Mamajamas.Collections.Invites();
      new Mamajamas.Views.FindFriends({
        el: '#findfriendsapp'
      });
    }

    // user profile
    if ($('#frm-create-profile').length > 0) {
      new Mamajamas.Views.UserProfile({
        el: '#frm-create-profile'
      });
    }

    // email settings
    if ($('#email-settings').length > 0) {
      new Mamajamas.Views.EmailSettings({
        el: '#frm-list-settings'
      });
    }

    // registry settings
    if ($('#registry-settings').length > 0) {
      new Mamajamas.Views.RegistrySettings({
        el: '#registry-settings'
      });
    }


    // list
    if ($('#my-list').length > 0) {
      new Mamajamas.Routers.ListItems();
      Mamajamas.Context.ListItemAdded = new Mamajamas.Views.ListItemAdded();
      Backbone.history.start();
    }

    // public list
    if ($('#publist').length > 0) {
      new Mamajamas.Routers.PublicListItems();
      Backbone.history.start();
    }

    // public authenticated users only list
    if ($("#private-modal").length > 0) {
      new Mamajamas.Views.PublicListPrivate();
    }

    // quiz
    if ($('#quiz-modal').length > 0) {
      new Mamajamas.Routers.Quiz();
      Backbone.history.start();
    }

    // footer
    $("#footer .nav-drop-trigger a.nav-drop-link").click(function() {
      event.preventDefault();
      return false;
    });
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
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
  return Mamajamas.initialize();
});
