Mamajamas.Views.SocialLinks = Backbone.View.extend({

  initialize: function() {
  },

  events: {
    "click .ss-social-circle": "shareDispatch",
    "click .ss-email": "shareDispatch"
  },

  render: function() {
    return this;
  },

  shareDispatch: function(event) {
    var socialPlatform = $(event.currentTarget).attr("title").toLowerCase();
    switch (socialPlatform) {
      case "facebook":
        this.shareFacebook(event);
        break;
      case "twitter":
        this.shareTwitter(event);
        break;
      case "email":
        this.shareEmail(event);
        break;
      default:
        return true;
    }
    return false;
  },

  shareEmail: function(event) {
    if (Mamajamas.Context.EmailShareModal) {
      Mamajamas.Context.EmailShareModal.show();
    }
  },

  shareFacebook: function(event) {
    FB.ui({
      method: "feed",
      link: window.location.href,
      // link: "http://www.mamajamas.com",
      caption: Mamajamas.Context.List.get("title"),
      picture: "http://mamajamas.s3.amazonaws.com/assets/mamajamas_bird.jpg",
      description: "Check out my list of baby gear on Mamajamas.",
    }, function(response) {
      // do nothing for now
    });
    return true;
  },

  shareTwitter: function(event) {
    var url = $(event.currentTarget).attr("href");
    var w = 550;
    var h = 400;
    var left = (screen.width) ? (screen.width-w) / 2 : 0;
    var top = (screen.height) ? (screen.height-h) / 2 : 0;
    popupWindow = window.open(
      url,
      'popUpWindow',
      'height=' + h + ',width=' + w + ',left=' + left + ',top=' + top + ',resizable=yes,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no,status=no,addressbar=no')
    return false;
  },
});
