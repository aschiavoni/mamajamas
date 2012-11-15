Mamajamas.Views.ProductTypeShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['product_types/show'],

  initialize: function() {
    this.$el.addClass("prod");
  },

  events: {
  },

  render: function(event) {
    this.$el.html(this.template({ productType: this.model.toJSON() }));
    return this;
  }
});

