window.Mamajamas.Views.SignupModal = Backbone.View.extend({

  initialize: function() {
    this.pwStrength = $("#password-strength");
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    this.initializeCollapsible();

    this.model.on('server:authenticating', this.showProgress, this)
  },

  events: {
    "click #bt-cancel": "hide",
    "click #bt-create-account": "submit",
    "keyup #user_password": "validatePassword"
  },

  render: function(event) {
    return this;
  },

  initializeCollapsible: function() {
    $(".collapsible", this.$el).collapsible({
      cssClose: "ss-directright",
      cssOpen: "ss-dropdown",
      speed: 200,
      // these names are confusing
      // animateClose is actually called when the collapsible expands
      animateClose: this.openCollapsible,
      animateOpen: this.closeCollapsible
    });
  },

  showProgress: function() {
    this.$el.progressIndicator('show');
  },

  hideProgress: function() {
    this.$el.progressIndicator('hide');
  },

  show: function() {
    this.$el.show();
  },

  hide: function() {
    this.$el.progressIndicator('hide').hide();
    this.pwStrength.html(null);
    return true; // reset button
  },

  openCollapsible: function(elem, opts) {
    elem.next().slideDown(opts.speed, function() {
      $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      // TODO: remove this if we get rid of inFieldLabels
      // it is necessary to refresh the placeholders
      // when the modal is re-opened
      $("input", this.$el).blur();
      $("#user_username", this.$el).focus();
      $(".fb-progress-container", this.$el).addClass("progress-disabled");
    });
  },

  closeCollapsible: function(elem, opts) {
    elem.next().slideUp(opts.speed, function() {
      $(".fb-progress-container", this).removeClass("progress-disabled");
    });
  },

  submit: function() {
    var _session = this.model;
    var _view = this;
    var $form = $("#new_user", this.$el);
    $("button[type=submit]", this).attr("disabled", "disabled");
    this.clearFormErrors();

    _session.trigger('server:authenticating');
    // post to the server
    // if the registration succeeds, it will return a window.location redirect.
    // if not, it returns the form markup and replaces the existing form.
    $.post($form.attr("action") + ".json", $form.serialize(), function(data) {
      _view.hideProgress();
      if (data.errors) {
        $("#password-strength", _view.$el).html(null);
        for (var errorField in data.errors) {
          var $field = $("#user_" + errorField, _view.$el);
          var $errorTag = $("<strong>").addClass("status-msg").addClass("error");
          $errorTag.html(data.errors[errorField][0]);
          $field.after($errorTag);
        }
      }
    });
    return false;
  },

  clearFormErrors: function() {
    $(".status-msg.error", this.$el).remove();
  },

  validatePassword: function() {
    // remove error msg if present
    var $userPassword = $("#user_password", this.$el);
    $userPassword.siblings(".status-msg.error").remove();
    if ($userPassword.val().length > 0)
      $("#password-strength", this.$el).html(this.checkPasswordStrength($userPassword.val()));
    else
      $("#password-strength", this.$el).html(null);
  },

  // see http://gazpo.com/2012/04/password-strength/
  checkPasswordStrength: function(password) {
    var strength = 0;
    var $result = $("#password-strength", this.$el);

    //if the password length is less than 6, return message.
    if (password.length < 6) {
      $result.removeClass();
      $result.addClass("status-msg pw-weak");
      return 'Too short';
    }

    //if length is 8 characters or more, increase strength value
    if (password.length > 7)
      strength += 1;
    //if password contains both lower and uppercase characters, increase strength value
    if (password.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/))
      strength += 1;
    //if it has numbers and characters, increase strength value
    if (password.match(/([a-zA-Z])/) && password.match(/([0-9])/))
      strength += 1;
    //if it has one special character, increase strength value
    if (password.match(/([!,%,&,@,#,$,^,*,?,_,~])/))
      strength += 1;
    //if it has two special characters, increase strength value
    if (password.match(/(.*[!,%,&,@,#,$,^,*,?,_,~].*[!,%,&,@,#,$,^,*,?,_,~])/))
      strength += 1;

    if (strength < 2 ) {
      $result.removeClass();
      $result.addClass('status-msg pw-weak');
      return 'Weak';
    } else if (strength == 2 ) {
      $result.removeClass();
      $result.addClass('status-msg pw-good');
      return 'Good';
    } else {
      $result.removeClass();
      $result.addClass('status-msg pw-strong');
      return 'Strong';
    }
  }

});
