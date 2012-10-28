window.Mamajamas.Views.AppAuth = Backbone.View.extend({
  initialize: function() {
    _session = this.model;
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
    "click #login-link": "login",
    "click #bt-fb-connect, #bt-fb-connect-s": "facebookLogin",
    "click #logout": "logout"
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
  },
  facebookLogin: function(event) {
    event.preventDefault();
    _session.login();
    return false;
  },
  logout: function() {
    _session.logout();
    return true; // server logout
  }
});
