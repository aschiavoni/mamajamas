// see http://gazpo.com/2012/04/password-strength/
function checkPasswordStrength(password) {
  var strength = 0;
  var result = $("#password-strength");

  //if the password length is less than 6, return message.
  if (password.length < 6) {
    result.removeClass();
    result.addClass("status-msg pw-weak");
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
    result.removeClass();
    result.addClass('status-msg pw-weak');
    return 'Weak';
  } else if (strength == 2 ) {
    result.removeClass();
    result.addClass('status-msg pw-good');
    return 'Good';
  } else {
    result.removeClass();
    result.addClass('status-msg pw-strong');
    return 'Strong';
  }
}

$(document).ready(function(){
  // signup stuff
  $("#create-account").on("click", "#bt-account-email", function(event) {
    $("#signup-modal").hide();
    $("#email-signup-modal").show(0, function() {
      $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      // TODO: remove this if we get rid of inFieldLabels
      // it is necessary to refresh the placeholders
      // when the modal is re-opened
      $("input").blur();
      $("#user_username").focus();
    });
    return false;
  });

  $("#create-account-email").on("click", "#bt-cancel", function(event) {
    $("#password-strength").html(null);
    $(".modal-wrap").hide();
    return true;
  });

  $("#create-account-email").on("keyup", "#user_password", function() {
    // remove error msg if present
    $(this).siblings(".status-msg.error").remove();
    if ($(this).val().length > 0)
      $("#password-strength").html(checkPasswordStrength($(this).val()));
    else
      $("#password-strength").html(null);
  });

  $("#create-account-email").on("submit", "form", function(event) {
    var form = $(this);
    $("input[type=submit]", this).attr("disabled", "disabled");
    $.post(form.attr("action"), form.serialize(), function(data) {
      $("#new_user").replaceWith(data);
      $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    });
    return false;
  });

  // login stuff
  $("#login-window").on("submit", "form", function(event) {
    var form = $(this);
    $("input[type=submit]", this).attr("disabled", "disabled");
    $.post(form.attr("action"), form.serialize(), function(data) {
      $("#login-form").replaceWith(data);
      $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#user_login").focus();
    });
    return false;
  });
});
