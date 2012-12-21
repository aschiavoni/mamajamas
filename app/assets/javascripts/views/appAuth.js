window.Mamajamas.Views.AppAuth = Backbone.View.extend({
  initialize: function() {
    this._session = this.model;
    this._postSignup = new Mamajamas.Views.PostSignup({
      model: this.model,
      el: '#post-signup-modal'
    });

    this._signupModal = new Mamajamas.Views.SignupModal({
      model: this.model,
      el: '#signup-modal'
    });

    this._loginModal = new Mamajamas.Views.LoginModal({
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
    this._signupModal.show();
    return false;
  },
  login: function() {
    this._loginModal.show();
    return false;
  },
  facebookLogin: function(event) {
    event.preventDefault();
    this._session.login();
    return false;
  },
  logout: function() {
    this._session.logout();
    return true; // server logout
  }
});
