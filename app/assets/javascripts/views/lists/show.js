Mamajamas.Views.ListShow = Backbone.View.extend({

  template: HandlebarsTemplates['lists/show'],

  initialize: function() {
    this.indexView = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });
  },

  events: {
    "click #babygear th.item": "sort",
    "click #babygear th.when": "sort",
    "click #babygear th.priority": "sort"
  },

  render: function() {
    this.$el.html(this.template);
    return this;
  },

  sort: function(event) {
    return this.indexView.sort(event);
  }

});
