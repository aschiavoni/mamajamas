Mamajamas.Views.ProductTypeShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['product_types/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "click .add-item.button": "addItem",
    "click .ss-delete": "delete"
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
  },

  delete: function() {
    if (confirm("Are you sure you want to delete this item?")) {
      this.model.destroy({
        wait: true,
        success: function() {
          Mamajamas.Context.ListItems.remove(this.model);
        },
        error: function(model, response, options) {
          Mamajamas.Context.Notifications.error("We could not remove this item at this time. Please try again later.");
        }
      });
    }
    return false;
  }

});
