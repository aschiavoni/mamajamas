Mamajamas.Collections.Invites = Backbone.Collection.extend({

  initialize: function() {
  },

  url: '/api/invites',

  model: Mamajamas.Models.Invite

});
