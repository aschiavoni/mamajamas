Mamajamas.Views.Base = Backbone.View.extend({

  initialize: function() {
  },

  isAuthenticated: function() {
    return Mamajamas.Context.User != null;
  },

  isGuestUser: function() {
    return Mamajamas.Context.User.get('guest');
  },

  unauthorized: function(redirect_path) {
    if (redirect_path) {
      $.cookies.set('guest_redirect_path', redirect_path, { path: "/" });
    }
    Mamajamas.Context.AppAuth.signup();
  },

});
