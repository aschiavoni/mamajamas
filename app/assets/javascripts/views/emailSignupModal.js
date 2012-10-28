window.Mamajamas.Views.EmailSignupModal = Backbone.View.extend({
  initialize: function() {
    _emailSignupModal = this;
    _pwStrength = $("#password-strength");
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  events: {
    "click #bt-cancel": "hide",
    "submit #new_user": "submit",
    "keyup #user_password": "validatePassword"
  },

  render: function(event) {
    return this;
  },

  show: function() {
    _emailSignupModal.$el.show(0, function() {
      $("label", this).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      // TODO: remove this if we get rid of inFieldLabels
      // it is necessary to refresh the placeholders
      // when the modal is re-opened
      $("input", this).blur();
      $("#user_username", this).focus();
    });
  },

  hide: function() {
    _pwStrength.html(null);
    _emailSignupModal.$el.hide();
    return true; // reset button
  },

  submit: function() {
    var $form = $("#new_user", this.$el);
    $("button[type=submit]", this).attr("disabled", "disabled");

    // post to the server
    // if the registration succeeds, it will return a window.location redirect.
    // if not, it returns the form markup and replaces the existing form.
    $.post($form.attr("action"), $form.serialize(), function(data) {
      $form.replaceWith(data);
      $form = $("#new_user", this.$el); // get a ref to the new element
      $("label", $form).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    });
    return false;
  },

  validatePassword: function() {
    // remove error msg if present
    var $userPassword = $("#user_password", this.$el);
    $userPassword.siblings(".status-msg.error").remove();
    if ($userPassword.val().length > 0)
      $("#password-strength").html(this.checkPasswordStrength($userPassword.val()));
    else
      $("#password-strength").html(null);
  },

  // see http://gazpo.com/2012/04/password-strength/
  checkPasswordStrength: function(password) {
    var strength = 0;
    var $result = $("#password-strength", _emailSignupModal.$el);

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
