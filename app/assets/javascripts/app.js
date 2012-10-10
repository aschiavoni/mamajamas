$(document).ready(function(){
  $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

  $("#signup").click(function(event) {
    $("#signup-modal").show(0, function() {
      $("#user_username").focus();
    });
    return false;
  });

  $("#bt-cancel").click(function(event) {
    $(".modal-wrap").hide();
    return false;
  });

  $("#create-account").on("submit", "form", function(event) {
    var form = $(this);
    $.post(form.attr("action"), form.serialize(), function(data) {
      $("#new_user").replaceWith(data);
      $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    });
    return false;
  });
});
