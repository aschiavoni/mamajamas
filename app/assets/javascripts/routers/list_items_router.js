Mamajamas.Routers.ListItems = Backbone.Router.extend({

  initialize: function() {
    // use a global to store the list items collection
    Mamajamas.Context.ListItems = new Mamajamas.Collections.ListItems();
  },

  routes: {
    "": "index"
  },

  index: function() {
    var listView = new Mamajamas.Views.ListShow();
    $("#my-list").html(listView.render().$el);

    var view = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });

    var listEntries = $("#my-list").data("list-entries");
    Mamajamas.Context.ListItems.reset(listEntries);
  }

});
