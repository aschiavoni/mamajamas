Mamajamas.Views.ListItemNew = Backbone.View.extend({

  tagName: "div",

  template: HandlebarsTemplates["list_items/new"],

  className: "prod new-mode clearfix",

  initialize: function() {
    this._errMap = this.errorFieldMap();
  },

  events: {
    "submit .new-placeholder": "save",
    "click .save-item": "save",
    "click .cancel-item": "cancel",
  },

  render: function(event) {
    var _view = this;

    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var priorityView = new Mamajamas.Views.ListItemPriority({
      model: this.model
    });
    $(".prod-when-own", this.$el).append(priorityView.render().$el);

    var ageRangeView = new Mamajamas.Views.ListItemAgeRange({
      model: this.model
    });
    $(".prod-when-own", this.$el).append(ageRangeView.render().$el);

    var quantityView = new Mamajamas.Views.ListItemQuantity({
      model: this.model
    });
    $(".prod-when-own", this.$el).append(quantityView.render().$el);

    if (Mamajamas.Context.List.isAllCategory()) {
      var categoryView = new Mamajamas.Views.ListItemCategory({
        model: this.model
      });
      $(".prod-category", this.$el).append(categoryView.render().$el);
    }

    this.initializeAutocomplete();

    _.defer(function() {
      _view.inFieldLabels();
      $("#new_list_item_name", _view.$el).focus();
    });

    return this;
  },

  close: function() {
    this.$el.remove();
    this.trigger("list_item:new:closed", this);
  },

  cancel: function(event) {
    this.close();
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    _view.clearErrors();
    var itemName = $("#new_list_item_name", this.$el).val();
    var pluralName = this.model.get("product_type_plural_name");
    if (pluralName == null) pluralName = itemName;
    var attributes = {
      category_id: this.model.get("category_id"),
      priority: this.model.get("priority"),
      age: this.model.get("age"),
      image_url: this.model.get("image_url"),
      product_type_id: this.model.get("product_type_id"),
      quantity: this.model.get("quantity"),
      owned: this.model.get("owned"),
      product_type_name: itemName,
      product_type_plural_name: pluralName,
      owned: false,
      placeholder: true,
      show_chooser: true
    };

    _view.oldModel = _view.model;
    _view.model = Mamajamas.Context.ListItems.create(attributes, {
      wait: true,
      success: function(model) {
        _view.close();
      },
      error: function(model, response) {
        _view.model = _view.oldModel;
        _view.handleError(model, response);
      }
    });
    return false;
  },

  handleError: function(item, response) {
    var _view = this;
    if (response.status == 422) {
      var errors = $.parseJSON(response.responseText).errors;
      for (var err in errors) {
        if (err == "category_id")
          _view.showCategoryError(errors, err);
        else
        _view.showError(errors, err);
      }
    }
  },

  showError: function(errors, field) {
    var $field = $(this._errMap[field]);
    var $errSpan = $("<span/>");
    $errSpan.addClass("status-msg").addClass("error");
    $errSpan.html(errors[field]);
    $field.after($errSpan);
    $field.focus();
  },

  showCategoryError: function(errors, field) {
    var $errSpan = $("<span/>");
    $errSpan.addClass("status-msg").addClass("error");
    $errSpan.html(errors[field]);
    $(".cat-select", this.$el).append($errSpan);
  },

  clearErrors: function() {
    $(".status-msg.error", this.$el).remove();
  },

  errorFieldMap: function() {
    return {
      name: "#new_list_item_name",
      category_id: "#new_list_item_name",
      product_type_name: "#new_list_item_name"
    };
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = "/api/list/product_types/";

    $("#new_list_item_name", this.$el).autocomplete({
      source: function(request, response) {
        $.getJSON(url, { filter: request.term }, function(data) {
          response($.map(data, function(item) {
            return {
              label: item.name,
              value: item
            }
          }))
        });
      },
      focus: function(event, ui) {
        return false;
      },
      select: function(event, ui) {
        $(event.target).val(ui.item.value.name);
        _view.model.set("product_type_id", ui.item.value.id);
        _view.model.set("image_url", ui.item.value.image_name);
        _view.model.set("product_type_plural_name", ui.item.value.plural_name);
        _view.inFieldLabels();

        return false;
      }
    });
  },

  inFieldLabels: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

});
