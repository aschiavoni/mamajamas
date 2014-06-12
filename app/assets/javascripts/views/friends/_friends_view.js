// This 'inheritance' structure is a little flaky, especially under
// phantomjs in test mode. not sure why but it might be worth a
// refactor at some point

Mamajamas.Views.FriendsView = function (options) {
  this.padHeight = "20";
  this.targetElement = "",
  $(window).resize($.proxy(this.sizeContent, this));

  Backbone.View.apply(this, [options]);
};

_.extend(Mamajamas.Views.FriendsView.prototype, Backbone.View.prototype, {

  // TODO: duplicate code from _base.js
  // need to figure out a multi-inheritance thing or refactor into a helper
  isAuthenticated: function() {
    return Mamajamas.Context.User != null;
  },

  isFacebookConnected: function() {
    return this.isAuthenticated() &&
      Mamajamas.Context.User.get("is_facebook_connected");
  },

  isGoogleConnected: function() {
    return this.isAuthenticated() &&
      Mamajamas.Context.User.get("is_google_connected");
  },

  unauthorized: function(redirect_path) {
    if (redirect_path) {
      $.cookies.set("after_sign_in_path", redirect_path, { path: "/" });
    }
    Mamajamas.Context.AppAuth.signup();
  },

  sizeContent: function() {
    var newHeight = $(window).height() - $("#hed-wrap").height() - $("#title").height() - $(".menu").height() - $("#footer").height() - this.padHeight + "px";
    $(this.targetElement).css("height", newHeight);
  },

  follow: function(view) {
    if (this.isAuthenticated()) {
      var btn = $(view.currentTarget);
      var li = btn.parents("li");
      var followedId = li.data("friend-id");
      var view = this;

      var data = { relationship: { followed_id: followedId } };
      $.post('/relationships', data, function(response) {
        li.replaceWith(response);
        view.initExpandables();
      });
    } else {
      this.unauthorized("/friends/find");
    }
    return false;
  },

  unfollow: function(view) {
    if (this.isAuthenticated()) {
      var btn = $(view.currentTarget);
      var li = btn.parents("li");
      var relationshipId = li.data("relationship-id");
      var view = this;

      var data = { _method: "delete" };
      $.post("/relationships/" + relationshipId, data, function(response) {
        li.replaceWith(response);
        view.initExpandables();
      });
    } else {
      this.unauthorized("/friends/find");
    }
    return false;
  },

  initializeScrolling: function() {
    // keep header, primary nav and list nav fixed and scroll the rest
    // of the page
    $("#hed-wrap").scrollToFixed();

    $("#primary").scrollToFixed({
      marginTop: $('#hed-wrap').outerHeight(true)
    });

    $(".menu").scrollToFixed({
      marginTop: $('#hed-wrap').outerHeight(true)
    });
  },

  initExpandables: function() {
    $('div.expandable', this.$el).expander({
      expandPrefix:     '... ',
      expandText:       'Expand', // default is 'read more'
      userCollapseText: 'Collapse',  // default is 'read less'
      expandEffect: 'show',
      expandSpeed: 0,
      collapseEffect: 'hide',
      collapseSpeed: 0
    });
  },

  toggleSortList: function(event) {
    var $target = $(event.currentTarget);
    var $choiceDrop = $target.parents(".choicedrop");
    var $list = $choiceDrop.find("ul");

    if ($list.is(":visible")) {
      $list.hide();
    } else {
      $list.show();
    }

    return false;
  },

  sort: function(event) {
    var $sortLink = $(event.currentTarget);
    var sortDisplayName = $sortLink.html();
    var sortName = $sortLink.data("sort");
    var $sortDisplay = $sortLink.parents(".choicedrop").children("a");
    $sortDisplay.html(sortDisplayName + " <span class=\"ss-dropdown\"></span>");
    window.location = this.sortRedirectPath(sortName);
    return false;
  },

  sortRedirectPath: function(sortName) {
    var path = window.location.pathname;

    var redirectPath;
    if (path.match(/\/followers/)) {
      redirectPath = "/friends/followers/" + sortName;
    } else if (path.match(/\/following/)) {
      redirectPath = "/friends/following/" + sortName;
    } else {
      redirectPath = "/friends/find/" + sortName;
    }

    return redirectPath;
  },

});

Mamajamas.Views.FriendsView.extend = Backbone.View.extend;
