Mamajamas.Views.UserProfile = Backbone.View.extend({

  initialize: function() {
    this.birthdayField = $("#field-bdate", this.$el);
    this.birthdayField.datepicker({
      changeMonth: true,
      changeYear: true,
      defaultDate: "-25y"
    });

    var _view = this;
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#bt-upload", "#profile-photo").click(function(event) {
      event.preventDefault();
      _view.showFilePicker(_view);
    });
  },

  events: {
    "keyup #profile_username": "updateUrl",
    "click img.date-picker": "showBirthdayCalendar",
    "click #bt-upload": "showFilePicker"
  },

  updateUrl: function(event) {
    var $listUrlSuffix = $(".list-url-suffix", this.$el);
    var $userName = $("#profile_username", this.$el);
    $listUrlSuffix.html($userName.val().toLowerCase());
  },

  showBirthdayCalendar: function(event) {
    this.birthdayField.focus();
    return false;
  },

  showFilePicker: function(view) {
    $("#profile_profile_picture", view.$el).trigger("click");
  }

});
