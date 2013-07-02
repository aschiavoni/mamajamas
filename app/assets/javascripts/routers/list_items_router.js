Mamajamas.Routers.ListItems = Backbone.Router.extend({

  initialize: function() {
    // use a global to store the list items collection
    Mamajamas.Context.ListItems = new Mamajamas.Collections.ListItems();

    // use a global to store the suggestions collection
    Mamajamas.Context.ProductTypeSuggestions = new Mamajamas.Collections.ProductTypeSuggestions();
  },

  routes: {
    "": "index"
  },

  isListStale: function() {
    var listEntriesLoadedAt = $("#my-list").data("list-entries-loaded-at");
    var loadedAt = new Date(Date.parse(listEntriesLoadedAt));
    var now = new Date();
    var loadedDiff = Math.floor((now.getTime() - loadedAt.getTime()) / 1000);

    return loadedDiff > 10;
  },

  index: function() {
    $(document).ajaxError(function(e, xhr, options) {
      Mamajamas.Context.AppAuth.completeRegistration();
    });

    var listView = new Mamajamas.Views.ListShow({
      model: Mamajamas.Context.List
    });
    $("#my-list").html(listView.render().$el);

    // get list entries from json in dom
    var listEntries = $("#my-list").data("list-entries");

    if (listEntries.length > 0 && !this.isListStale()) {
      Mamajamas.Context.ListItems.reset(listEntries);
    }
    else {
      Mamajamas.Context.ListItems.fetch({
        data: { category: Mamajamas.Context.List.get('category_id') }
      });
    }

  }

});
