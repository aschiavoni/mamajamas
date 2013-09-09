window.Mamajamas.Views.FindFriends = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "49";
    this.targetElement = ".friends-list";
    this.sizeContent();

    $(".tabs").accessibleTabs({
      tabhead:'h2',
      fx:"fadeIn",
      tabsListClass:'menu',
      autoAnchor:true,
      saveState:true
    });
  },

  events: {
  },

  render: function(event) {
    return this;
  },

});
