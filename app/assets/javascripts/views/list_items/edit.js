Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  initialize: function() {
    console.log("initializing ListItemsEdit...");
    this.$el.
      addClass("prod").
      addClass("prod-filled").
      addClass("edit-mode");
  },

  events: {
    "click .save-item.button": "save"
  },

  render: function(event) {
    var $template = Handlebars.compile($("#add-item-template").html());
    this.$el.html($template(this.model.toJSON()));
    return this;
  },

  save: function(event) {
    var $form = $("form", this.$el);
    $.post($form.attr("action"), $form.serialize(), function(data) {
      console.log(data);
    });
    return false;
  }
});
