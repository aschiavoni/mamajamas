window.Mamajamas.Views.FindFriends = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "49";
    this.targetElement = ".friends-list";
    this.sizeContent();

    this.tabs = $(".tabs").accessibleTabs({
      tabhead:'h2',
      fx:"fadeIn",
      tabsListClass:'menu',
      autoAnchor:true,
      saveState:true
    });

    if (!Mamajamas.Context.User.get("is_facebook_connected")) {
      this.tabs.showAccessibleTab(2);
    }
  },

  events: {
    "click #facebookfriends": "selectFacebookFriends",
    "click button.follow": "follow",
    "click button.unfollow": "unfollow"
  },

  render: function(event) {
    return this;
  },

  selectFacebookFriends: function(event) {
    if (!Mamajamas.Context.User.get('is_facebook_connected')) {
      Mamajamas.Context.LoginSession.facebook_connect();
    }
  },

});
