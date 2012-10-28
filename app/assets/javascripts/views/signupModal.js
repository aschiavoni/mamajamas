window.Mamajamas.Views.SignupModal = Backbone.View.extend({
  initialize: function() {
    _signupModal = this;
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
    _signupModal.$el.progressIndicator('show');
  },
  hideProgress: function() {
    _signupModal.$el.progressIndicator('hide');
  },
  show: function() {
    _signupModal.$el.show();
  },
  hide: function() {
    _signupModal.$el.progressIndicator('hide').hide();
  }
});
