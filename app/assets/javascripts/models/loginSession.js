window.Mamajamas.Models.LoginSession = Backbone.Model.extend({
  defaults: {
    username: null,
    first_name: null,
    last_name: null,
    permissions: ''
  },
  initialize: function() {
    _session = this;
    // can respond to facebookLoginStatus events if needed later
    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        _session.trigger('facebookLoginStatus', 'connected');
      } else if (response.status === 'not_authorized') {
        _session.trigger('facebookLoginStatus', 'not_authorized');
      } else {
        _session.trigger('facebookLoginStatus', 'not_logged_in');
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
