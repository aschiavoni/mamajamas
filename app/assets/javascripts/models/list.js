Mamajamas.Models.List = Backbone.Model.extend({

  url: '/list',

  initialize: function(){
    var memento = new Backbone.Memento(this);
    _.extend(this, memento);
  },

  isAllCategory: function() {
    return !('category' in Mamajamas.Context.List.attributes);
  },

});
