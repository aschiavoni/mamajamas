window.Mamajamas.Views.SignupModal = Backbone.View.extend({
  initialize: function() {
    _signupModal = this;
    _emailSignupModal = new Mamajamas.Views.EmailSignupModal({
      el: "#email-signup-modal"
    });

    this.model.on('serverAuthenticating', this.showProgress)
    this.model.on('serverAuthenticated', this.hide)
  },
  events: {
    "click #bt-cancel": "hide",
    "click #bt-account-email": "emailSignup"
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
  },
  emailSignup: function() {
    this.hide();
    _emailSignupModal.show();
    return false;
  }
});
