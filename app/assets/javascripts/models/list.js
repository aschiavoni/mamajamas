Mamajamas.Models.List = Backbone.Model.extend({

  isAllCategory: function() {
    return !('category' in Mamajamas.Context.List.attributes);
  },

});
