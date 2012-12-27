Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/edit'],

  className: "prod prod-filled edit-mode",

  initialize: function() {
    _errMap = this.errorFieldMap();
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:when_to_buy", this.updateWhenToBuy, this);
    this.model.on("change:priority", this.updatePriority, this);
  },

  events: {
    "submit .new-list-item": "save",
    "change input[name='list_item[owned]']": "toggleOwnedCheckbox",
    "change .owned-cb": "toggleOwnedRadioButtons",
    "click .cancel-item.button": "cancel"
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);

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
    this.scopedElement("list_item_name").focus();
  },

  updateRating: function() {
    this.scopedElement("list_item_rating").val(this.model.get("rating"));
  },

  updateWhenToBuy: function() {
    this.scopedElement("list_item_when_to_buy").val(this.model.get("when_to_buy"));
  },

  updatePriority: function() {
    this.scopedElement("list_item_priority").val(this.model.get("priority"));
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = "/api/categories/" + _view.model.get("category_id") + "/" + this.model.get("product_type_id");

    this.scopedElement("list_item_name").autocomplete({
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
        _view.scopedElement("list_item_link").val(ui.item.value.url);
        _view.scopedElement("list_item_image_url").val(ui.item.value.image_url);

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
      name: this.scopedElement("list_item_name").val(),
      link: this.scopedElement("list_item_link").val(),
      notes: this.scopedElement("list_item_notes").val(),
      product_type_id: this.scopedElement("list_item_product_type_id").val(),
      product_type: _view.model.get("product_type"),
      category_id: this.scopedElement("list_item_category_id").val(),
      priority: this.scopedElement("list_item_priority").val(),
      when_to_buy: this.scopedElement("list_item_when_to_buy").val(),
      rating: this.scopedElement("list_item_rating").val(),
      image_url: this.scopedElement("list_item_image_url").val(),
      owned: $("input[name='list_item[owned]']:checked").val() == "1"
    };

    if (_view.model.isNew()) {
      // creating a new list item
      Mamajamas.Context.ListItems.create(attributes, {
        wait: true,
        success: function() {
          _view.$el.remove();
          _view.options.parent.moveToBottom();
        },
        error: function(model, response) {
          _view.handleError(model, response);
        }
      });
    } else {
      _view.model.save(attributes, {
        wait: true,
        silent: true, // don't fire change events for this save
        success: function() {
          _view.$el.remove();
          _view.options.parent.render();
          _view.options.parent.editing = false;
          _view.options.parent.$el.show();
        },
        error: function(model, response) {
          _view.handleError(model, response);
        }
      });
    }

    return false;
  },

  cancel: function(event) {
    this.options.parent.$el.show();
    this.options.parent.editing = false;
    this.$el.remove();
    return true;
  },

  toggleOwnedCheckbox: function(event) {
    var owned = $("input[name='list_item[owned]']:checked", this.$el).val() == "1";
    $("td.own input[type='checkbox']", this.$el).attr("checked", owned);
  },

  toggleOwnedRadioButtons: function(event) {
    var owned = $(event.target).is(":checked");
    var selector;
    if (owned)
      selector = this.scopedSelector("list_item_owned_1");
    else
      selector = this.scopedSelector("list_item_owned_0");

    $(selector).attr("checked", "checked");
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
      name: this.scopedSelector("list_item_name"),
      link: this.scopedSelector("list_item_link")
    };
  },

  scopedSelector: function(id) {
    return ("#" + id + "_" + this.model.get("product_type_id"));
  },

  scopedElement: function(id) {
    return $(this.scopedSelector(id), this.$el);
  }

});
