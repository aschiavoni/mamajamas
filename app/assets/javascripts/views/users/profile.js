Mamajamas.Views.UserProfile = Backbone.View.extend({

  initialize: function() {
    this.birthdayField = $("#field-bdate", this.$el);
    this.birthdayField.datepicker({
      changeMonth: true,
      changeYear: true,
      defaultDate: "-25y"
    });
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  events: {
    "keyup #user_username": "updateUrl",
    "click img.date-picker": "showBirthdayCalendar"
  },

  updateUrl: function(event) {
    var $listUrlSuffix = $(".list-url-suffix", this.$el);
    var $userName = $("#user_username", this.$el);
    $listUrlSuffix.html($userName.val().toLowerCase());
  },

  showBirthdayCalendar: function(event) {
    this.birthdayField.focus();
    return false;
  }

});
