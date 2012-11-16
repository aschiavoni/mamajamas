Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  className: "prod prod-filled edit-mode",

  events: {
    "click .save-item.button": "save",
    "click .cancel-item.button": "cancel"
  },

  render: function(event) {
    var $template = Handlebars.compile($("#add-item-template").html());
    this.$el.html($template(this.model.toJSON()));

    return this;
  },

  setup: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#list_item_name", this.$el).focus();
  },

  save: function(event) {
    var $form = $("form", this.$el);
    $.post($form.attr("action"), $form.serialize(), function(data) {
      console.log(data);
    });
    return false;
  },

  cancel: function(event) {
    this.options.productType.$el.show();
    this.$el.remove();
    return true;
  }
});
