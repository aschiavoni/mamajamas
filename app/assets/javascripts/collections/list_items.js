Mamajamas.Collections.ListItems = Backbone.Collection.extend({

  initialize: function() {
    this.sortField = "name";
    this.sortDirection = "ASC";
  },

  url: function() {
    var url = "/list/list_items";
    var list = Mamajamas.Context.List;
    if (list) {
      var category = Mamajamas.Context.List.get("category");
      if (category != null)
        url = "/list/" + category + "/list_items";
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
  },

  sortStrategies: {
    name: function(listEntry, compareTo) {
      return listEntry.get("name").localeCompare(compareTo.get("name"));
    },
    name_desc: function(listEntry, compareTo) {
      return compareTo.get("name").localeCompare(listEntry.get("name"));
    },
    when_to_buy: function(listEntry, compareTo) {
      return listEntry.get("when_to_buy").localeCompare(compareTo.get("when_to_buy"));
    },
    when_to_buy_desc: function(listEntry, compareTo) {
      return compareTo.get("when_to_buy").localeCompare(listEntry.get("when_to_buy"));
    },
    priority: function(listEntry) {
      return listEntry.get("priority");
    },
    priority_desc: function(listEntry) {
      return listEntry.get("priority") * -1;
    }
  },

  isAscending: function() {
    return this.sortDirection === "ASC";
  },

  toggleSortDirection: function() {
    this.sortDirection = this.isAscending() ? "DESC" : "ASC";
  },

  changeSort: function(sortField) {
    if (this.sortField === sortField) {
      this.toggleSortDirection();
    }
    this.sortField = sortField;

    var sortFunction = this.isAscending() ? sortField : (sortField + "_desc");
    this.comparator = this.sortStrategies[sortFunction];
  }

});
