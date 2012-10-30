window.Mamajamas.Models.LoginSession = Backbone.Model.extend({
  defaults: {
    username: null,
    first_name: null,
    last_name: null,
    permissions: ''
  },
  initialize: function() {
    _session = this;
    this.updateLoginStatus();
  },
  updateLoginStatus: function() {
    // can respond to these events if needed later
    FB.getLoginStatus(function(response) {
      _session.trigger('facebookLoginStatus', response);
      if (response.status === 'connected') {
        _session.trigger('facebookConnected', response);
      } else if (response.status === 'not_authorized') {
        _session.trigger('facebookNotAuthorized', response);
      } else {
        _session.trigger('facebookNotLoggedIn', response);
      }
    });
  },
  logout: function() {
    return FB.logout();
  },
  login: function() {
    return FB.login(function(response) {
      if (response.authResponse) {
        _session.saveSession();
      }
      else {
        // cancelled
        // TODO: what do we do here?
      }
    }, { scope: this.get('scope') });
  },
  saveSession: function() {
    _session.trigger('serverAuthenticating');

    $.get("/users/auth/facebook/callback", function(data) {
      _session.set({
        username: data.username,
        first_name: data.first_name,
        last_name: data.last_name
      });
      _session.trigger('serverAuthenticated');
    });
  }
});
