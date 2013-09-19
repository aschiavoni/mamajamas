window.Mamajamas.Views.FindFriends = Mamajamas.Views.FriendsView.extend({

  initialize: function() {
    this.padHeight = "49";
    this.targetElement = ".friends-list";
    this.sizeContent();
    this._errMap = this.errorFieldMap();

    this.tabs = $(".tabs").accessibleTabs({
      tabhead:'h2',
      fx:"fadeIn",
      tabsListClass:'menu',
      autoAnchor:true,
      saveState:true
    });

    if (!window.location.hash && !Mamajamas.Context.User.get("is_facebook_connected")) {
      this.tabs.showAccessibleTab(2);
    }
  },

  events: {
    "click #facebookfriends": "selectFacebookFriends",
    "click button.follow": "follow",
    "click button.unfollow": "unfollow",
    "click button.fb-invite": "facebookInvite",
    "submit #frm-create-email-invite": "emailInvite",
  },

  render: function(event) {
    return this;
  },

  selectFacebookFriends: function(event) {
    if (!Mamajamas.Context.User.get('is_facebook_connected')) {
      Mamajamas.Context.LoginSession.facebook_connect();
    }
  },

  emailInvite: function(event) {
    event.preventDefault();
    var _view = this;
    var $form = $(event.currentTarget);
    var invite = {
      provider: $("#invite_provider", $form).val(),
      email: $("#invite_email", $form).val(),
      name: $("#invite_name", $form).val(),
      from: $("#invite_from", $form).val(),
      message: $("#invite_message", $form).val()
    };

    this.clearErrors();
    this.createInvite(invite, function(model) {
      _view.clearEmailForm($form);
      Mamajamas.Context.Notifications.info("Thanks, your invite has been sent!");
    }, function(errors) {
      for (var err in errors) {
        _view.showError(errors, err);
      }
    });
    return false;
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
        }, function(model) {
          _view.toggleInvitedButton($button);
        }, function(errors) {
          var errMsg = "Please try again later."
          if (errors) {
            var firstErrKey = _.keys(errors)[0];
            errMsg = errors[firstErrKey][0];
          }
          Mamajamas.Context.Notifications.error(errMsg);
        });
      }
    });

    return false;
  },

  createInvite: function(invite, success_cb, error_cb) {
    var _view = this;
    Mamajamas.Context.Invites.create({
      invite: invite
    }, {
      wait: true,
      success: success_cb,
      error: function(model, response) {
        var errors = $.parseJSON(response.responseText).errors;
        error_cb(errors);
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

  clearEmailForm: function($form) {
    $("#invite_email", $form).val("").blur();
    $("#invite_name", $form).val("").blur();
    $("#invite_from", $form).val("").blur();
    $("#invite_message", $form).val("").blur();
    _.defer(function() {
      $("label", $form).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#invite_email", $form).focus();
    });
  },

  showError: function(errors, field) {
    var $field = $(this._errMap[field]);
    var fieldErrors = errors[field];
    if (fieldErrors != null) {
      var $errSpan = $("<span/>");
      $errSpan.addClass("status-msg").addClass("error");
      $errSpan.html(fieldErrors[0]);
      $field.after($errSpan);
      $field.focus();
    }
  },

  errorFieldMap: function() {
    return {
      email: '#invite_email',
      name: '#invite_name',
      from: '#invite_from',
      message: '#invite_message'
    };
  },

  clearErrors: function() {
    $(".status-msg.error").remove();
  },

});
