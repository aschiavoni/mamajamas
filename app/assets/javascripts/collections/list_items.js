Mamajamas.Collections.ListItems = Backbone.Collection.extend({

  initialize: function() {
    this.sortField = "age";
    this.sortDirection = "ASC";
  },

  url: "/list/list_items",

  model: Mamajamas.Models.ListItem,

  sortStrategies: {
    owned: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "owned");
    },
    owned_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "owned");
    },
    name: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "name");
    },
    name_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "name");
    },
    rating: function(listEntry, compareTo) {
      // flip things around for ratings
      return this.sortByField(listEntry, compareTo, "rating") * - 1;
    },
    rating_desc: function(listEntry, compareTo) {
      // flip things around for ratings
      return this.reverseSortByField(listEntry, compareTo, "rating") * - 1;
    },
    age: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "age_position");
    },
    age_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "age_position");
    },
    priority: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "priority");
    },
    priority_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "priority");
    },
    updated_at: function(listEntry, compareTo) {
      return this.sortByField(listEntry, compareTo, "updated_at");
    },
    updated_at_desc: function(listEntry, compareTo) {
      return this.reverseSortByField(listEntry, compareTo, "updated_at");
    },
  },

  sortByField: function(listEntry, compareTo, fieldName) {
    var fieldVal = this.calculateSortField(listEntry, fieldName);
    var compareToField = this.calculateSortField(compareTo, fieldName);
    return fieldVal.localeCompare(compareToField);
  },

  reverseSortByField: function(listEntry, compareTo, fieldName) {
    var fieldVal = this.calculateSortField(listEntry, fieldName);
    var compareToField = this.calculateSortField(compareTo, fieldName);
    return compareToField.localeCompare(fieldVal);
  },

  calculateSortField: function(listEntry, fieldName) {
    var type = null;
    var isPlaceholder = listEntry.get("placeholder");
    if (this.isAscending())
      type = isPlaceholder ? 1 : 0;
    else
      type = isPlaceholder ? 0 : 1;

    if (isPlaceholder && fieldName == "name")
      fieldName = "product_type_name";

    // flip things around for ratings
    if (fieldName == "rating")
      type = type == 1 ? 0 : 1;

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
  },

  itemCount: function() {
    return this.where({ placeholder: false }).length;
  },

  clearPlaceholders: function(productTypeId, productTypeName) {
    if (productTypeId == null || productTypeId.toString().length == 0) {
      this.clearPlaceholdersByName(productTypeName);
    } else {
      this.clearPlaceholdersById(productTypeId);
    }
  },

  clearPlaceholdersById: function(productTypeId) {
    var query = {
      product_type_id: parseInt(productTypeId),
      placeholder: true
    };
    var placeholders = Mamajamas.Context.ListItems.where(query);
    _.each(placeholders, function(placeholder) {
      placeholder.destroy();
    });
  },

  clearPlaceholdersByName: function(productTypeName) {
    var query = {
      product_type_name: productTypeName,
      placeholder: true
    };
    var placeholders = Mamajamas.Context.ListItems.where(query);
    _.each(placeholders, function(placeholder) {
      placeholder.destroy();
    });
  },

});
