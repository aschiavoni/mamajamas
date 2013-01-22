Mamajamas.Views.ListItemNew = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/new'],

  className: "prod new-mode",

  initialize: function() {
    this._errMap = this.errorFieldMap();
  },

  events: {
    "click .save-item": "save",
    "click .cancel-item": "cancel"
  },

  render: function(event) {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var whenToBuyView = new Mamajamas.Views.ListItemWhenToBuy({
      model: this.model
    });
    this.$el.append(whenToBuyView.render().$el);

    var priorityView = new Mamajamas.Views.ListItemPriority({
      model: this.model
    });
    this.$el.append(priorityView.render().$el);

    this.initializeAutocomplete();

    return this;
  },

  setup: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#product_type_name", this.$el).focus();
  },

  cancel: function(event) {
    this.$el.remove();
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    _view.clearErrors();
    var attributes = {
      type: "ProductType",
      category_id: this.model.get("category_id"),
      priority: this.model.get("priority"),
      when_to_buy: this.model.get("when_to_buy"),
      name: $("#product_type_name", this.$el).val()
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

  updateWhenToBuy: function() {
    $("#product_type_when_to_buy", this.$el).val(this.model.get("when_to_buy"));
  },

  updatePriority: function() {
    $("#product_type_priority", this.$el).val(this.model.get("priority"));
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
      name: "#product_type_name"
    };
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = "/api/list/product_types/";

    $("#product_type_name", this.$el).autocomplete({
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

        // re-initialize the inFieldLabels plugin
        $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

        return false;
      }
    });
  }

});
