Mamajamas.Routers.PublicListItems = Backbone.Router.extend({

  initialize: function() {
    // use a global to store the list items collection
    Mamajamas.Context.ListItems = new Mamajamas.Collections.ListItems();
  },

  routes: {
    "": "index"
  },

  index: function() {
    var listView = new Mamajamas.Views.PublicListShow({
      model: Mamajamas.Context.List,
      collection: Mamajamas.Context.ListItems,
      el: '#public-list'
    });

    var listEntries = $("#public-list").data("list-entries");
    Mamajamas.Context.ListItems.reset(listEntries);
  }

});

