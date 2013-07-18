window.Mamajamas.Views.AppAuth = Backbone.View.extend({

  initialize: function() {
    this.model.on('facebook:disconnected', this.serverLogout, this);

    var signupView = Mamajamas.Views.SignupModal;
    if (this.isGuest())
      signupView = Mamajamas.Views.CompleteRegistrationModal;

    this._signupModal = new signupView({
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

  completeRegistration: function() {
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

  isGuest: function() {
    if (Mamajamas.Context.User)
      return Mamajamas.Context.User.get('guest');
    else
      return false;
  },

});
