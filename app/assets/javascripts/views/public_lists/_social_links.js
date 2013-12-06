Mamajamas.Views.SocialLinks = Backbone.View.extend({

  initialize: function() {
  },

  events: {
    "click .ss-social-circle": "shareDispatch",
  },

  render: function() {
    return this;
  },

  shareDispatch: function(event) {
    var socialPlatform = $(event.currentTarget).attr("title").toLowerCase();
    switch (socialPlatform) {
      case "facebook":
        this.shareFacebook();
        break;
      default:
        return true;
    }
    return false;
  },

  shareFacebook: function() {
    FB.ui({
      method: "feed",
      link: window.location.href,
      // link: "http://www.mamajamas.com",
      caption: Mamajamas.Context.List.get("title"),
    }, function(response) {
      // do nothing for now
    });
  },

});
