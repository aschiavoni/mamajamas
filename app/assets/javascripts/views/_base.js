Mamajamas.Views.Base = Backbone.View.extend({

  initialize: function() {
  },

  isGuestUser: function() {
    return Mamajamas.Context.User.get('guest');
  },

  unauthorized: function() {
    console.log('unauthorized');
    Mamajamas.Context.User.trigger('server:unauthorized');
  },

});
