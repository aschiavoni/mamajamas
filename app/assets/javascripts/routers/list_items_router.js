Mamajamas.Routers.ListItems = Backbone.Router.extend({

  initialize: function() {
    this.collection = new Mamajamas.Collections.ListItems();
    this.collection.fetch();
  },

  routes: {
    "": "index"
  },

  index: function() {
    var view = new Mamajamas.Views.ListItemsIndex({
      collection: this.collection
    });

    $("#my-list").html(view.render().$el);
  }
});
