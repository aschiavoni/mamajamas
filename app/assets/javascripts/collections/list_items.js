Mamajamas.Collections.ListItems = Backbone.Collection.extend({

  url: function() {
    var url = "/list/list_items.json";
    var list = Mamajamas.Context.List;
    if (list) {
      var category = Mamajamas.Context.List.get("category");
      if (category != null)
        url = "/list/" + category + "/list_items.json";
    }
    return url;
  },

  model: function(attrs, options) {
    var m = null;

    switch(attrs.type) {
      case "ListItem":
        m = new Mamajamas.Models.ListItem(attrs, options);
        break;
      case "ProductType":
        m = new Mamajamas.Models.ProductType(attrs, options);
        break;
      default:
        m = new Mamajamas.Models.ListEntry(attrs, options);
    }

    return m;
  }

});
