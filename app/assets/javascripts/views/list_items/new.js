Mamajamas.Views.ListItemNew = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/new'],

  className: "prod new-mode",

  initialize: function() {
    this._errMap = this.errorFieldMap();
  },

  events: {
    "submit .new-placeholder": "save",
    "click .save-item": "save",
    "click .cancel-item": "cancel"
  },

  render: function(event) {
    var _view = this;

    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var ageRangeView = new Mamajamas.Views.ListItemAgeRange({
      model: this.model
    });
    this.$el.append(ageRangeView.render().$el);

    var priorityView = new Mamajamas.Views.ListItemPriority({
      model: this.model
    });
    this.$el.append(priorityView.render().$el);

    this.initializeAutocomplete();

    _.defer(function() {
      $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#list_item_name", _view.$el).focus();
    });

    return this;
  },

  cancel: function(event) {
    this.$el.remove();
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    _view.clearErrors();
    var itemName = $("#list_item_name", this.$el).val();
    var attributes = {
      category_id: this.model.get("category_id"),
      priority: this.model.get("priority"),
      age: this.model.get("age"),
      image_url: this.model.get("image_url"),
      product_type_id: this.model.get("product_type_id"),
      product_type_name: itemName,
      placeholder: true
    };

    _view.model = Mamajamas.Context.ListItems.create(attributes, {
      wait: true,
      success: function(model) {
        _view.remove();
      },
      error: function(model, response) {
        _view.handleError(model, response);
      }
    });
    return false;
  },

  updateAgeRange: function() {
    $("#list_item_age", this.$el).val(this.model.get("age"));
  },

  updatePriority: function() {
    $("#list_item_priority", this.$el).val(this.model.get("priority"));
  },

  handleError: function(item, response) {
    var _view = this;
    if (response.status == 422) {
      var errors = $.parseJSON(response.responseText).errors;
      for (var err in errors) {
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

  clearErrors: function() {
    $(".status-msg.error", this.$el).remove();
  },

  errorFieldMap: function() {
    return {
      name: "#list_item_name",
      category_id: "#list_item_name"
    };
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = "/api/list/product_types/";

    $("#list_item_name", this.$el).autocomplete({
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
        _view.model.set("image_url", ui.item.value.image_url);

        // re-initialize the inFieldLabels plugin
        $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

        return false;
      }
    });
  }

});
