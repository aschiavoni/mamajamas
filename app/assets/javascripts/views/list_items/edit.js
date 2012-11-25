Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/edit'],

  className: "prod prod-filled edit-mode",

  initialize: function() {
    _errMap = this.errorFieldMap();
    this.model.on("change:rating", this.updateRating, this);
  },

  events: {
    "submit #new_list_item": "save",
    "click .cancel-item.button": "cancel"
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));

    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);
    this.initializeAutocomplete();

    return this;
  },

  setup: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#list_item_name", this.$el).focus();
  },

  updateRating: function() {
    $("#list_item_rating", this.$el).val(this.model.get("rating"));
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = "/api/categories/" + _view.model.get("category_id") + "/" + this.model.get("product_type_id");

    $("#list_item_name", _view.$el).autocomplete({
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
        $("#list_item_link", _view.$el).val(ui.item.value.url);

        // re-initialize the inFieldLabels plugin
        $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

        return false;
      }
    });
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    _view.clearErrors();

    attributes = {
      type: "ListItem",
      name: $("#list_item_name").val(),
      link: $("#list_item_link").val(),
      notes: $("#list_item_notes").val(),
      product_type_id: $("#list_item_product_type_id").val(),
      product_type: _view.model.get("product_type"),
      category_id: $("#list_item_category_id").val(),
      priority: $("#list_item_priority").val(),
      when_to_buy: $("#list_item_when_to_buy").val(),
      rating: $("#list_item_rating").val(),
      owned: $("input[name='list_item[owned]']:checked").val() == "1"
    };

    if (_view.model.isNew() == null) {
      // creating a new list item
      Mamajamas.Context.ListItems.create(attributes, {
        wait: true,
        success: function() {
          _view.$el.remove();
          _view.options.parent.moveToBottom();
        },
        error: _view.handleError
      });
    } else {
      _view.model.save(attributes, {
        wait: true,
        silent: true, // don't fire change events for this save
        success: function() {
          _view.$el.remove();
          _view.options.parent.render();
          _view.options.parent.$el.show();
        },
        error: _view.handleError
      });
    }

    return false;
  },

  cancel: function(event) {
    this.options.parent.$el.show();
    this.$el.remove();
    return true;
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
