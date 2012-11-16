Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  className: "prod prod-filled edit-mode",

  events: {
    "submit #new_list_item": "add",
    "click .cancel-item.button": "cancel"
  },

  render: function() {
    var $template = Handlebars.compile($("#add-item-template").html());
    this.$el.html($template(this.model.toJSON()));

    return this;
  },

  setup: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#list_item_name", this.$el).focus();
  },

  add: function(event) {
    event.preventDefault();
    Mamajamas.Context.ListItems.create({
      type: "ListItem",
      name: $("#list_item_name").val(),
      link: $("#list_item_link").val(),
      notes: $("#list_item_notes").val(),
      product_type_id: $("#list_item_product_type_id").val(),
      category_id: $("#list_item_category_id").val(),
      priority: $("#list_item_priority").val(),
      when_to_buy: $("#list_item_when_to_buy").val(),
    });
    this.$el.remove();
    return false;
  },

  cancel: function(event) {
    this.options.productType.$el.show();
    this.$el.remove();
    return true;
  }
});
