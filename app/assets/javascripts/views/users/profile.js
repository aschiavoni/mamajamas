Mamajamas.Views.UserProfile = Backbone.View.extend({

  initialize: function() {
    BrowserDetect.init();
    this.birthdayField = $("#field-bdate", this.$el);
    this.birthdayField.datepicker({
      changeMonth: true,
      changeYear: true,
      defaultDate: "-25y",
      yearRange: "-53:-15",
      onChangeMonthYear: function(year, month, inst) {
        var date = $(this).datepicker('getDate');
        date.setFullYear(year);
        date.setMonth(month - 1);
        $(this).datepicker('setDate', date);
      }
    });

    this.$profilePictureContainer = $("#profile-photo");
    this.$profilePicture = $("#profile-photo > img");
    this.$profilePictureProgress = $("#profile-photo .progress-container img.progress");
    this.$profilePictureUploadText = $('#profile-photo p.instruction');
    this.$form = $('#frm-create-profile');

    this.initializeProfilePictureUploads();

    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

    if (this.ie9orLower()) {
      $("#profile-photo-file").show();
      $("#bt-upload", this.$profilePictureContainer).hide();
      $(".instruction", this.$profilePictureContainer).hide();
    }
  },

  events: {
    "keyup #profile_username": "updateUrl",
    "click img.date-picker": "showBirthdayCalendar"
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

  ie9orLower: function() {
    return (BrowserDetect.browser == 'Explorer' && BrowserDetect.version <= 9);
  },

  initializeProfilePictureUploads: function() {
    var _view = this;

    $("#bt-upload", "#profile-photo").click(function(event) {
      event.preventDefault();
      $("#profile_profile_picture", _view.$el).trigger("click");
    });


    $("#profile_profile_picture", this.$el).fileupload({
      dataType: "json",
      dropZone: _view.$profilePicture,
      pasteZone: _view.$profilePicture,
      maxNumberOfFiles: 1,
      start: function(e) {
        _.defer(function() {
          _view.$profilePictureUploadText.hide();
          _view.$profilePictureContainer.progressIndicator("show");
        });
      },
      stop: function(e) {
        setTimeout(function() {
          _view.$profilePictureContainer.progressIndicator("hide");
          _view.$profilePictureUploadText.show();
        }, 600);
        if (_view.ie9orLower())
          _view.$form.submit();
      },
      add: function(e, data) {
        var types = /(\.|\/)(gif|jpe?g|png)$/i;
        var file = data.files[0];
        if (types.test(file.type) || types.test(file.name)) {
          data.submit();
        } else {
          Mamajamas.Context.Notifications.error(file.name + " does not appear to be an image file.");
        }
      },
      done: function(e, data) {
        var profilePic = data.result.profile_picture;
        _view.$profilePicture.attr("src", profilePic.url);
      }
    });
  },

});
