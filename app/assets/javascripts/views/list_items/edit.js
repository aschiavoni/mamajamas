Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  className: "prod prod-filled edit-mode",

  initialize: function() {
    _edit = this;
    _errMap = this.errorFieldMap();
    this.model.on("change:rating", this.updateRating);
  },

  events: {
    "submit #new_list_item": "add",
    "click .cancel-item.button": "cancel"
  },

  render: function() {
    var $template = Handlebars.compile($("#add-item-template").html());
    this.$el.html($template(this.model.toJSON()));

    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);

    return this;
  },

  setup: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#list_item_name", this.$el).focus();
  },

  updateRating: function() {
    $("#list_item_rating", this.$el).val(this.get("rating"));
  },

  add: function(event) {
    event.preventDefault();
    this.clearErrors();

    attributes = {
      type: "ListItem",
      name: $("#list_item_name").val(),
      link: $("#list_item_link").val(),
      notes: $("#list_item_notes").val(),
      product_type_id: $("#list_item_product_type_id").val(),
      product_type: this.model.get("product_type"),
      category_id: $("#list_item_category_id").val(),
      priority: $("#list_item_priority").val(),
      when_to_buy: $("#list_item_when_to_buy").val(),
      rating: $("#list_item_rating").val(),
      owned: $("input[name='list_item[owned]']:checked").val() == "1"
    };

    Mamajamas.Context.ListItems.create(attributes, {
      wait: true,
      success: function() {
        _edit.$el.remove();
        _edit.options.productType.moveToBottom();
      },
      error: this.handleError
    });

    return false;
  },

  cancel: function(event) {
    this.options.productType.$el.show();
    this.$el.remove();
    return true;
  },

  handleError: function(item, response) {
    if (response.status == 422) {
      var errors = $.parseJSON(response.responseText).errors;
      for (var err in errors) {
        _edit.showError(errors, err);
      }
    }
  },

  showError: function(errors, field) {
    var $field = $(_errMap[field]);
    var $errSpan = $("<span/>");
    $errSpan.addClass("status-msg").addClass("error");
    $errSpan.html(errors[field]);
    $field.after($errSpan);
    $field.focus();
  },

  clearErrors: function() {
    $(".status-msg.error").remove();
  },

  errorFieldMap: function() {
    return {
      name: "#list_item_name",
      link: "#list_item_link"
    };
  }
});