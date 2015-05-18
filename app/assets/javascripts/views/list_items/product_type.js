Mamajamas.Views.ProductType = Mamajamas.Views.ListItemDropdown.extend({
  tagName: "span",

  className: "own",

  template: HandlebarsTemplates["list_items/product_type"],

  initialize: function() {},

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop.product-type ul li a": "selectProductType"
  },

  render: function() {
    this.$el.html(this.template({
      listItem: this.model.listItem.toJSON(),
      list: this.model.list.toJSON(),
      allowChange: this.model.allowChange
    }));
    return this;
  },

  selectProductType: function(event) {
    if (event)
      event.preventDefault();

    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();
    var productTypeId = $target.data('product-type-id');

    this.model.listItem.set("product_type_name", value);
    this.model.listItem.set("product_type_id", productTypeId);
    this.model.allowChange = false;
    $list.hide();
    this.render();

    return false;
  },

});
