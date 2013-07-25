Mamajamas.Views.PublicListSidebar = Backbone.View.extend({

  initialize: function() {
  },

  events: {
    "click #bt-follow .follow": "follow",
    "click #bt-follow .unfollow": "unfollow",
  },

  render: function() {
    return this;
  },

  follow: function(event) {
    event.preventDefault();

    var _view = this;
    var btnContainer = $('#bt-follow', this.$el);
    var followedId = btnContainer.data("owner-id");

    var data = { relationship: { followed_id: followedId }, format: "json" };
    $.post('/relationships', data, function(response) {
      btnContainer.data("relationship-id", response.relationship_id);
      _view.toggleFollowButton($(event.target));
    });

    return false;
  },

  unfollow: function(event) {
    event.preventDefault();

    var _view = this;
    var btnContainer = $('#bt-follow', this.$el);
    var relationshipId = btnContainer.data("relationship-id");

    var data = { _method: "delete" };
    $.post("/relationships/" + relationshipId, data, function(response) {
      btnContainer.data("relationship-id", null);
      _view.toggleFollowButton($(event.target));
    });

    return false;
  },

  toggleFollowButton: function(btn) {
    if (btn.html() == "Follow") {
      btn.removeClass("follow").addClass("unfollow");
      btn.html("Unfollow");
    } else {
      btn.removeClass("unfollow").addClass("follow");
      btn.html("Follow");
    }
  },

});
