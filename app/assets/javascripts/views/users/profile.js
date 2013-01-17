Mamajamas.Views.UserProfile = Backbone.View.extend({

  initialize: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  events: {
    "keyup #user_username": "updateUrl"
  },

  updateUrl: function(event) {
    var $listUrlSuffix = $(".list-url-suffix", this.$el);
    var $userName = $("#user_username", this.$el);
    $listUrlSuffix.html($userName.val().toLowerCase());
  }

});
