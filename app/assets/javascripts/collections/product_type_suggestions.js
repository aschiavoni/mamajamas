Mamajamas.Collections.ProductTypeSuggestions = Backbone.Collection.extend({

  initialize: function(models, options) {
    this.productTypeId = options.productTypeId;
  },

  url: function() {
    return "/api/suggestions/" + this.productTypeId;
  },

  model: Mamajamas.Models.ProductTypeSuggestion

});
