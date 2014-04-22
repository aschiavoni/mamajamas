Mamajamas.Views.Base = Backbone.View.extend({

  initialize: function() {
  },

  isAuthenticated: function() {
    return Mamajamas.Context.User != null;
  },

  userHasList: function() {
    return Mamajamas.Context.User.get("has_list") == true;
  },

  isFacebookConnected: function() {
    return this.isAuthenticated() &&
      Mamajamas.Context.User.get("is_facebook_connected");
  },

  isGuestUser: function() {
    return Mamajamas.Context.User.get('guest');
  },

  unauthorized: function(redirect_path) {
    if (redirect_path) {
      $.cookies.set("after_sign_in_path", redirect_path, { path: "/" });
    }
    Mamajamas.Context.AppAuth.signup();
  },

});
