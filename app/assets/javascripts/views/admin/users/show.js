Mamajamas.Views.Admin.UsersShow = Backbone.View.extend({

  initialize: function() {
    var _view = this;

    $(".admin-button .bt-become").click(function(event) {
      return confirm("Are you sure you want to impersonate this user?");
    });

    $(".admin-button .bt-user-delete").click(function(event) {
      return confirm("Are you sure you want to delete this user?");
    });

    $(".user-list .toggle-notes").click(function(event) {
      event.preventDefault();
      var $link = $(event.currentTarget);
      var $adminNotes = $("#admin-notes");
      var $formContainer = $("#user-notes-form");
      var $textArea = $("textarea", $formContainer);
      $link.hide();
      $adminNotes.hide();
      $formContainer.show();
      $textArea.focus();
      return false;
    });

    $('form.edit-user-list').submit(function(event) {
      event.preventDefault();
      var url = $(this).attr("action");
      $.post(url, $(this).serialize());
      return false;
    });

    $("#list_featured, #list_expert").change(function(event) {
      $(this).parents('form').submit();
    });
  },

});
