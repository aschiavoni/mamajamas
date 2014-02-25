window.Mamajamas.Views.FriendPicker = Backbone.View.extend({

  initialize: function() {
    this.initializeScrolling();
  },

  events: {
    "click .follow-moms button.follow": "follow",
    "click .follow-moms button.unfollow": "unfollow"
  },

  render: function(event) {
    return this;
  },

  follow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var followedId = li.data("friend-id");

    var data = {
      relationship: { followed_id: followedId },
      no_notification: true,
      follow_friend: 1
    };
    $.post('/relationships', data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

  unfollow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var relationshipId = li.data("relationship-id");

    var data = { _method: "delete", follow_friend: 1 };
    $.post("/relationships/" + relationshipId, data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

});
