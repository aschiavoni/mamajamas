Mamajamas.Collections.ListItems = Backbone.Collection.extend({

  url: function() {
    var url = "/list/list_items.json";
    var category = $("#current-category").data("category");
    if (category != null)
      url = "/list/" + category + "/list_items.json";
    return url;
  },

  model: Mamajamas.Models.ListItem

});
