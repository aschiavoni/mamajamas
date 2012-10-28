window.Mamajamas.Views.SignupModal = Backbone.View.extend({
  initialize: function() {
    _signupModal = this;
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
  hide: function() {
    _signupModal.$el.progressIndicator('hide').hide();
  }
});
