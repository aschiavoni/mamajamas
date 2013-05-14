Mamajamas.Views.ListItemSearchResult = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search_result'],

  tagName: 'li',

  initialize: function() {
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

});
