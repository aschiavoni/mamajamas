Mamajamas.Views.ListItemSearchResult = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search_result'],

  tagName: 'li',

  initialize: function() {
  },

  events: {
    'click .add-to-list': 'selectItem',
    'click .product-image': 'doNothing',
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  selectItem: function(event) {
    event.preventDefault();
    this.trigger('search:product:selected', this.model);
    return false;
  },

  doNothing: function(event) {
    event.preventDefault();
    return false;
  },

});
