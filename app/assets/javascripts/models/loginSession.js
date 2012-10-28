window.Mamajamas.Models.LoginSession = Backbone.Model.extend({
  defaults: {
    username: null,
    first_name: null,
    last_name: null,
    permissions: ''
  },
  initialize: function() {
  },
  logout: function() {
    return FB.logout();
  },
  login: function(scope) {
    _session = this;
    return FB.login(function(response) {
      if (response.authResponse) {
        _session.saveSession();
      }
      else {
        // cancelled
        // TODO: what do we do here?
      }
    }, { scope: scope });
  },
  saveSession: function() {
    $.get("/users/auth/facebook/callback", function(data) {
      _session.set({
        username: data.username,
        first_name: data.first_name,
        last_name: data.last_name
      });
    });
  }
});
