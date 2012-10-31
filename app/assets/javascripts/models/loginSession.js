window.Mamajamas.Models.LoginSession = Backbone.Model.extend({
  defaults: {
    username: null,
    first_name: null,
    last_name: null,
    permissions: ''
  },
  initialize: function() {
    _session = this;
    if (Mamajamas.Context.User && _session.refreshTokenRequired()) {
      _session.on('facebookConnected', _session.refreshToken)
    }
    if (Mamajamas.Context.User && _session.updateFriendsRequired()) {
      _session.on('facebookConnected', _session.updateFriends);
    }
    _session.updateLoginStatus();
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
  refreshTokenRequired: function() {
    var lastRefresh = _session.refreshedTokenAt();
    if (!lastRefresh) {
      return true; // refresh if the cookie is not set
    }
    // refresh if it hasn't been refreshed in the last 20 minutes
    return (((new Date() - lastRefresh) / 1000) > ( 60 * 20 ));
  },
  refreshedTokenAt: function(newdate) {
    if (newdate) {
      $.cookie('fbtokref', newdate.getTime());
      return newdate;
    } else {
      var fbtokref = $.cookie('fbtokref');
      if (fbtokref) {
        var d = new Date();
        d.setTime(fbtokref);
        fbtokref = d;
      }
      return fbtokref;
    }
  },
  refreshToken: function(response) {
    // ideally this would exchange the token for a longer lived token
    // as of now, it just updates the token stored on the server
    _session.trigger('refreshingToken');
    var authResponse = response.authResponse;

    if (authResponse) {
      $.post("/users/facebook/update", authResponse, function(response) {
        if (response.success) {
          _session.refreshedTokenAt(new Date());
        }
        _session.trigger('refreshedToken');
      });
    }
  },
  updateFriendsRequired: function() {
    // refresh friends every day
    var lastUpdatedAt = Mamajamas.Context.User.get('friends_updated_at');
    return (((new Date() - lastUpdatedAt) / 1000) > ( 60 * 60 * 24 ))
  },
  updateFriends: function() {
    var fields = "id,name,first_name,last_name,picture";
    var opts = { fields: fields, type: "square" };
    FB.api("/me/friends", opts, function(response) {
      $.post("/users/facebook/friends", { friends: response.data }, function(response) {
        // do nothing
      });
    });
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
