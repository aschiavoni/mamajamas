Mamajamas.Views.Base = Backbone.View.extend({

  initialize: function() {
  },

  isGuestUser: function() {
    return Mamajamas.Context.User.get('guest');
  },

  unauthorized: function() {
    Mamajamas.Context.AppAuth.completeRegistration();
  },

});
