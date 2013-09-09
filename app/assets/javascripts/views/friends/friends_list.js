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

  follow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var followedId = li.data("friend-id");

    var data = { relationship: { followed_id: followedId } };
    $.post('/relationships', data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

  unfollow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var relationshipId = li.data("relationship-id");

    var data = { _method: "delete" };
    $.post("/relationships/" + relationshipId, data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

});
