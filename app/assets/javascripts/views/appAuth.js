window.Mamajamas.Views.AppAuth = Backbone.View.extend({
  initialize: function() {
    _postSignup = new Mamajamas.Views.PostSignup({
      model: this.model,
      el: '#post-signup-modal'
    });

    _signupModal = new Mamajamas.Views.SignupModal({
      model: this.model,
      el: '#signup-modal'
    });

    _loginModal = new Mamajamas.Views.LoginModal({
      model: this.model,
      el: '#login-modal'
    });
  },
  events: {
    "click #signup-link": "signup",
    "click #login-link": "login"
  },
  render: function(event) {
    return this;
  },
  signup: function() {
    _signupModal.show();
    return false;
  },
  login: function() {
    _loginModal.show();
    return false;
  }
});
