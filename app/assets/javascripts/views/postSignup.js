window.Mamajamas.Views.PostSignup = Backbone.View.extend({
  initialize: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    this.model.on("change", this.postSignupAction, this);
  },

  render: function(event) {
    return this;
  },

  postSignupAction: function() {
    if (this.model.get("sign_in_count") <= 1)
      this.show();
    else
      window.location = "/list";
  },

  show: function(event) {
    var $fbUsername = $("#facebook-username", this.$el);
    $fbUsername.val(this.model.get('username'));
    this.$el.show(0, function() {
      $("label", this).inFieldLabels({
        fadeDuration:200,fadeOpacity:0.55
      });
      $fbUsername.focus();
    });
  }
});
