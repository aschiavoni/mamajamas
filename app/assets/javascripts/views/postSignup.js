window.Mamajamas.Views.PostSignup = Backbone.View.extend({
  initialize: function() {
    this.model.on("change", this.show, this);
  },
  render: function(event) {
    return this;
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
