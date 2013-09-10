window.Mamajamas.Views.FriendsList = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "28";
    this.targetElement = ".friends-list";
    this.sizeContent();
  },

  events: {
    "click button.follow": "follow",
    "click button.unfollow": "unfollow"
  },

  render: function(event) {
    return this;
  },

});
