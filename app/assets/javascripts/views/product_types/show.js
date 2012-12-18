Mamajamas.Views.ProductTypeShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['product_types/show'],

  className: "prod",

  initialize: function() {
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "click .add-item.button": "addItem",
  },

  render: function(event) {
    this.$el.html(this.template({ productType: this.model.toJSON() }));
    return this;
  },

  addItem: function(event) {
    var addItem = new Mamajamas.Views.ListItemEdit({
      model: new Mamajamas.Models.ListItem({
        product_type: this.model.get("name"),
        product_type_id: this.model.get("id").replace("product-type-", ""),
        category_id: this.model.get("category_id"),
        priority: this.model.get("priority"),
        when_to_buy: this.model.get("when_to_buy"),
        image_url: "/assets/products/icons/" + this.model.get("image_name")
      }),
      parent: this
    });

    this.$el.after(addItem.render().$el);
    this.$el.hide();
    addItem.setup();

    return false;
  },

  moveToBottom: function() {
    this.$el.appendTo("#list-items");
    this.$el.show();
  }

});
