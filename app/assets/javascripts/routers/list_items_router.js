Mamajamas.Routers.ListItems = Backbone.Router.extend({

  initialize: function() {
    // use a global to store the list items collection
    Mamajamas.Context.ListItems = new Mamajamas.Collections.ListItems();
    Mamajamas.Context.ListItems.fetch();
  },

  routes: {
    "": "index"
  },

  index: function() {
    var view = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });

    $("#my-list").html(view.render().$el);
  }
});
