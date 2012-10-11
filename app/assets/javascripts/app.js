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
  $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

  $("#signup").click(function(event) {
    $("#signup-modal").show();
    return false;
  });

  $("#create-account").on("click", "#bt-cancel", function(event) {
    $(".modal-wrap").hide();
    return true;
  });


  $("#create-account").on("click", "#bt-account-email", function(event) {
    $("#signup-modal").hide();
    $("#email-signup-modal").show(0, function() {
      $("#user_username").focus();
    });
    return false;
  });

  $("#create-account-email").on("click", "#bt-cancel", function(event) {
    $(".modal-wrap").hide();
    return true;
  });

  $("#create-account-email").on("keyup", "#user_password", function() {
    // remove error msg if present
    $(this).siblings(".status-msg.error").remove();
    $("#password-strength").html(checkPasswordStrength($(this).val()));
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
});