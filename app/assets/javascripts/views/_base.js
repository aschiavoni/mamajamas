Mamajamas.Views.Base = Backbone.View.extend({

  initialize: function() {
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
