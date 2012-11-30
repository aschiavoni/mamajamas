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
      return this.sortByField(listEntry, compareTo, "name");
    },
    name_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "name");
    },
    when_to_buy: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "when_to_buy");
    },
    when_to_buy_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "when_to_buy");
    },
    priority: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "priority");
    },
    priority_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "priority");
    }
  },

  sortByField: function(listEntry, compareTo, fieldName) {
    var fieldVal = this.typeQualifiedModelField(listEntry, fieldName);
    var compareToField = this.typeQualifiedModelField(compareTo, fieldName);
    return fieldVal.localeCompare(compareToField);
  },

  reverseSortByField: function(listEntry, compareTo, fieldName) {
    var fieldVal = this.typeQualifiedModelField(listEntry, fieldName);
    var compareToField = this.typeQualifiedModelField(compareTo, fieldName);
    return compareToField.localeCompare(fieldVal);
  },

  typeQualifiedModelField: function(listEntry, fieldName) {
    var type = null;
    var isListItem = listEntry.get("type") == "ListItem";
    if (this.isAscending())
      type = isListItem ? 0 : 1;
    else
      type = isListItem ? 1 : 0;

    var val = listEntry.get(fieldName);
    return type + "-" + val;
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
