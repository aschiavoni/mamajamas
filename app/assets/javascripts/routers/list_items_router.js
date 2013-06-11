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
    Mamajamas.Context.ListItems.reset(listEntries);
  }

});
