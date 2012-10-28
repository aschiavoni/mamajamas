window.Mamajamas.Views.LoginModal = Backbone.View.extend({
  initialize: function() {
    _loginModal = this;
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

    this.model.on('serverAuthenticating', this.showProgress)
    this.model.on('serverAuthenticated', this.hide)
  },
  events: {
    "click #bt-cancel": "hide"
  },
  render: function(event) {
    return this;
  },
  showProgress: function() {
    _loginModal.$el.progressIndicator('show');
  },
  hideProgress: function() {
    _loginModal.$el.progressIndicator('hide');
  },
  show: function() {
    _loginModal.$el.show(0, function() {
      $("#user_login", this).focus();
    });
  },
  hide: function() {
    _loginModal.$el.progressIndicator('hide').hide();
  }
});
