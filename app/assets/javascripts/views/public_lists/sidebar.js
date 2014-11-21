Mamajamas.Views.PublicListSidebar = Mamajamas.Views.Base.extend({

  $followButton: null,

  initialize: function() {
    $("div.expandable", this.$el).expander('destroy').expander({
      expandPrefix:     '... ',
      expandText:       'Expand', // default is 'read more'
      userCollapseText: 'Collapse',  // default is 'read less'
      expandEffect: 'show',
      expandSpeed: 0,
      collapseEffect: 'hide',
      collapseSpeed: 0,
      slicePoint: 265
    });
    this.$followButton = $("#bt-follow", this.$el);
  },

  events: {
    "click #bt-follow": "toggleRelationship",
    "click .show-all-friends": "showAllFriends"
  },

  render: function() {
    return this;
  },

  toggleRelationship: function(event) {
    event.preventDefault();

    if (!this.isAuthenticated() || this.isGuestUser()) {
      this.unauthorized(window.location.pathname, this.signupPrompt());
      return false;
    }

    if (this.$followButton.hasClass("bt-active")) {
      this.unfollow();
    } else {
      this.follow();
    }
    return false;
  },

  signupPrompt: function() {
    var name = this.$followButton.data("owner-name");
    var prompt = "Sign up to follow " + name;
    prompt += " and get started keeping track of your baby gear."
    return prompt;
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

  showAllFriends: function(event) {
    event.preventDefault();
    var $container = $(event.currentTarget).parent();
    var $ul = $container.siblings('ul');
    $ul.css("height", null);
    $container.remove();

    return false;
  },

});
