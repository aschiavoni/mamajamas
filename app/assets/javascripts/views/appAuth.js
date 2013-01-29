window.Mamajamas.Views.AppAuth = Backbone.View.extend({
  initialize: function() {
    this.model.on('facebook:disconnected', this.serverLogout, this);

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
    "click #logout": "logout",
    "click #myaccount-dd": "doNothing"
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
    this.model.login();
    return false;
  },
  logout: function() {
    this.model.logout();
    return false;
  },
  serverLogout: function(fbresponse) {
    $("#server-logout").click();
  },

  doNothing: function(event) {
    event.preventDefault();
    return false;
  }
});
