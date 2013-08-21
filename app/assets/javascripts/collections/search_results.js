Mamajamas.Collections.SearchResults = Backbone.Collection.extend({

  initialize: function() {
  },

  url: '/api/products',

  model: Mamajamas.Models.SearchResult,

});
