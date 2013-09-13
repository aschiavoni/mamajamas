window.Mamajamas.Views.FindFriends = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "49";
    this.targetElement = ".friends-list";
    this.sizeContent();

    this.tabs = $(".tabs").accessibleTabs({
      tabhead:'h2',
      fx:"fadeIn",
      tabsListClass:'menu',
      autoAnchor:true,
      saveState:true
    });

    if (!Mamajamas.Context.User.get("is_facebook_connected")) {
      this.tabs.showAccessibleTab(2);
    }

    this.on("find_friends:invite:created", this.toggleInvitedButton, this);
  },

  events: {
    "click #facebookfriends": "selectFacebookFriends",
    "click button.follow": "follow",
    "click button.unfollow": "unfollow",
    "click button.fb-invite": "facebookInvite"
  },

  render: function(event) {
    return this;
  },

  selectFacebookFriends: function(event) {
    if (!Mamajamas.Context.User.get('is_facebook_connected')) {
      Mamajamas.Context.LoginSession.facebook_connect();
    }
  },

  facebookInvite: function(event) {
    event.preventDefault();

    var _view = this;
    var $button = $(event.currentTarget);
    var fbUid = $button.parents("li").data("fbuid");
    var name = $button.parents("li").data("name");
    var picUrl = $button.parents("li").data("pictureurl");

    FB.ui({
      method: 'send',
      link: 'http://mamajamas-meta.herokuapp.com/',
      to: fbUid,
      name: 'Mamajamas',
      description: 'With so much on your mind right now, who has time to figure out exactly what you will need for the new baby? Mamajamas offers a super-easy way for you to build a personalized, prioritized list of baby gear.',
      picture: 'http://mamajamas-meta.herokuapp.com/assets/logo-m@2x.png'
    }, function(response) {
      if (response && response.success)  {
        _view.createInvite({
          uid: fbUid,
          name: name,
          picture_url: picUrl,
          provider: "facebook"
        }, $button);
      }
    });

    return false;
  },

  createInvite: function(invite, $button) {
    var _view = this;
    Mamajamas.Context.Invites.create({
      invite: invite
    }, {
      wait: true,
      success: function(model) {
        _view.trigger("find_friends:invite:created", $button);
      },
      error: function(model, response) {
        var errMsg = "Please try again later."
        var errors = $.parseJSON(response.responseText).errors;
        if (errors) {
          var firstErrKey = _.keys(errors)[0];
          errMsg = errors[firstErrKey][0];
        }
        Mamajamas.Context.Notifications.error(errMsg);
      },
      complete: function() {
      }
    });
  },

  toggleInvitedButton: function($button) {
    $button.addClass("bt-active").
      removeClass("fb-invite").
      html("<span class=\"ss-check\"></span>Invited");
  },

});
