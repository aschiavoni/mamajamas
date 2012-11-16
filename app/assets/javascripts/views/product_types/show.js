Mamajamas.Views.ProductTypeShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['product_types/show'],

  className: "prod",

  events: {
    "click .add-item.button": "addItem",
  },

  render: function(event) {
    this.$el.html(this.template({ productType: this.model.toJSON() }));
    return this;
  },

  addItem: function(event) {
    var addItem = new Mamajamas.Views.ListItemEdit({
      model: new Mamajamas.Models.ListItem(),
      productType: this
    });

    this.$el.after(addItem.render().$el);
    this.$el.hide();
    addItem.setup();

    return false;
  }
});
