Mamajamas.Views.PublicListSidebar = Backbone.View.extend({

  $followButton: null,

  initialize: function() {
    this.$followButton = $("#bt-follow", this.$el);
  },

  events: {
    "click #bt-follow": "toggleRelationship",
  },

  render: function() {
    return this;
  },

  toggleRelationship: function(event) {
    event.preventDefault();
    if (this.$followButton.hasClass("bt-active")) {
      this.unfollow();
    } else {
      this.follow();
    }
    return false;
  },

  follow: function() {
    var _view = this;
    var followedId = this.$followButton.data("owner-id");

    var data = { relationship: { followed_id: followedId }, format: "json" };
    $.post('/relationships', data, function(response) {
      _view.$followButton.data("relationship-id", response.relationship_id);
      _view.showFollowingButton();
    });
  },

  unfollow: function() {
    var _view = this;
    var relationshipId = this.$followButton.data("relationship-id");

    var data = { _method: "delete" };
    $.post("/relationships/" + relationshipId, data, function(response) {
      _view.$followButton.data("relationship-id", null);
      _view.showFollowButton();
    });
  },

  showFollowButton: function() {
    this.$followButton.removeClass("bt-active").empty();
    this.$followButton.html("<span class=\"ss-check\"></span>Follow");
  },

  showFollowingButton: function() {
    this.$followButton.addClass("bt-active").empty();
    this.$followButton.html("<span class=\"bt-text1\"><span class=\"ss-check\"></span>Following</span><em class=\"bt-text2\"><span class=\"ss-delete\"></span>Unfollow</em>");
  },

});
