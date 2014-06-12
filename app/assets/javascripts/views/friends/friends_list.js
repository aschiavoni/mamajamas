window.Mamajamas.Views.FriendsList = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "28";
    this.targetElement = ".friends-list";
    this.sizeContent();
    // have to check that initializeScrolling is defined
    // otherwise, this blows up under phantomjs in test
    if (this.initializeScrolling)
      this.initializeScrolling();

    if (this.initExpandables)
      this.initExpandables();

    $(".friends-sort .choicedrop a").click($.proxy(this.toggleSortList, this));
    $(".friends-sort .choicedrop ul li a").click($.proxy(this.sort, this));
  },

  events: {
    "click button.follow": "follow",
    "click button.unfollow": "unfollow",
  },

  render: function(event) {
    return this;
  },

});
