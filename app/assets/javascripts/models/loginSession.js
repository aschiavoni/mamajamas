window.Mamajamas.Models.LoginSession = Backbone.Model.extend({
  defaults: {
    username: null,
    first_name: null,
    last_name: null,
    permissions: ''
  },
  initialize: function() {
    this._session = this;
    if (Mamajamas.Context.User) {
      if (this.refreshTokenRequired()) {
        this.on('facebook:connected', this.refreshToken)
      }
      if (this.updateFriendsRequired()) {
        this.on('facebook:connected', this.updateFriends);
      }
    }
    this.updateLoginStatus();
  },
  updateLoginStatus: function() {
    if(typeof FB == 'undefined')
      return;

    var _session = this._session;
    // can respond to these events if needed later
    FB.getLoginStatus(function(response) {
      _session.trigger('facebook:loginstatus', response);
      if (response.status === 'connected') {
        _session.trigger('facebook:connected', response);
      } else if (response.status === 'not_authorized') {
        _session.trigger('facebook:notauthorized', response);
      } else {
        _session.trigger('facebook:notloggedin', response);
      }
    });
  },
  logout: function() {
    if(typeof FB == 'undefined')
      return;
    return FB.logout();
  },
  login: function() {
    if(typeof FB == 'undefined')
      return;
    var _session = this._session;
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
    var lastRefresh = this.refreshedTokenAt();
    if (!lastRefresh) {
      return true; // refresh if the cookie is not set
    }
    // refresh if it hasn't been refreshed in the last 20 minutes
    return (((new Date() - lastRefresh) / 1000) > ( 60 * 20 ));
  },
  refreshedTokenAt: function(newdate) {
    if (newdate) {
      $.cookies.set('fbtokref', newdate.getTime());
      return newdate;
    } else {
      var fbtokref = $.cookies.get('fbtokref');
      if (fbtokref) {
        var d = new Date();
        d.setTime(fbtokref);
        fbtokref = d;
      }
      return fbtokref;
    }
  },
  refreshToken: function(response) {
    var _session = this._session;
    // ideally this would exchange the token for a longer lived token
    // as of now, it just updates the token stored on the server
    _session.trigger('facebook:token:refreshing');
    var authResponse = response.authResponse;

    if (authResponse) {
      $.post("/registrations/facebook/update", authResponse, function(response) {
        if (response.success) {
          _session.refreshedTokenAt(new Date());
        }
        _session.trigger('facebook:token:refreshed');
      });
    }
  },
  updateFriendsRequired: function() {
    if (!Mamajamas.Context.User)
      return false;

    // refresh friends every day
    var lastUpdatedAt = Mamajamas.Context.User.get('friends_updated_at');
    return (((new Date() - lastUpdatedAt) / 1000) > ( 60 * 60 * 24 ))
  },
  updateFriends: function(fbresponse) {
    if(typeof FB == 'undefined')
      return;
    // fbresponse is the fb response from FB.login or Db.getLoginStatus
    var fields = "id,name,first_name,last_name,picture";
    var opts = { fields: fields, type: "square" };
    FB.api("/me/friends", opts, function(response) {
      var data = { uid: fbresponse.authResponse.userID, friends: response.data };
      $.post("/registrations/facebook/friends", data, function(response) {
        // do nothing
      });
    });
  },
  saveSession: function() {
    var _session = this._session;
    _session.trigger('server:authenticating');

    $.get("/users/auth/facebook/callback", function(data) {
      _session.set({
        username: data.username,
        first_name: data.first_name,
        last_name: data.last_name,
        sign_in_count: data.sign_in_count
      });
      _session.trigger('server:authenticated');
      _session.updateLoginStatus();
    });
  }
});
