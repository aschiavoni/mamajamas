Mamajamas.Views.ListItemEdit = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/edit'],

  className: "prod prod-filled edit-mode",

  initialize: function() {
    _errMap = this.errorFieldMap();
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:age", this.updateAgeRange, this);
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

    if (!Mamajamas.Context.User.is_facebook_connected || !this.model.isNew()) {
      $(".facebook-sharing", this.$el).remove();
    }

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);

    var ageRangeView = new Mamajamas.Views.ListItemAgeRange({
      model: this.model
    });
    this.$el.append(ageRangeView.render().$el);

    var priorityView = new Mamajamas.Views.ListItemPriority({
      model: this.model
    });
    this.$el.append(priorityView.render().$el);

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

  updateAgeRange: function() {
    $("#list_item_age", this.$el).val(this.model.get("age"));
  },

  updatePriority: function() {
    $("#list_item_priority", this.$el).val(this.model.get("priority"));
  },

  initializeAutocomplete: function() {
    var _view = this;
    var productTypeId = this.model.get("product_type_id");
    if (!productTypeId)
      productTypeId = 0; // ugh, magic number
    var url = "/api/categories/" + _view.model.get("category_id") + "/" + productTypeId;

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
        $("#list_item_link", _view.$el).val(ui.item.value.url);
        $("#list_item_image_url", _view.$el).val(ui.item.value.image_url);

        // re-initialize the inFieldLabels plugin
        $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

        return false;
      }
    });
  },

  save: function(event) {
    event.preventDefault();

    var curPos = $("#list-items tr").index(this.$el);
    Mamajamas.Context.List.set("current_position", curPos);

    var _view = this;
    _view.clearErrors();

    attributes = {
      name: $("#list_item_name", this.$el).val(),
      link: $("#list_item_link", this.$el).val(),
      notes: $("#list_item_notes", this.$el).val(),
      product_type_id: $("#list_item_product_type_id", this.$el).val(),
      product_type: _view.model.get("product_type"),
      product_type_name: _view.model.get("product_type_name"),
      category_id: $("#list_item_category_id", this.$el).val(),
      priority: $("#list_item_priority", this.$el).val(),
      age: $("#list_item_age", this.$el).val(),
      rating: $("#list_item_rating", this.$el).val(),
      image_url: $("#list_item_image_url", this.$el).val(),
      owned: $("input[name='list_item[owned]']:checked").val() == "1",
      placeholder: false
    };

    if (_view.model.isNew()) {
      // creating a new list item
      _view.model = Mamajamas.Context.ListItems.create(attributes, {
        wait: true,
        success: function() {
          _view.$el.remove();
          _view.options.parent.remove();
          if (_view.shouldShareOnFacebook())
            _view.shareOnFacebook();
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

  shouldShareOnFacebook: function() {
    return $(".chk-fb-share", this.$el).is(":checked");
  },

  shareOnFacebook: function() {
    FB.api('/me/feed', 'post', {
      message: "I've added a new item to my Mamajamas list!",
      link: this.model.get('link'),
      picture: this.model.get('image_url'),
      name: this.model.get('name')
    },function(data) {
      // do nothing
    });
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
      selector = $("#list_item_owned_1");
    else
      selector = $("#list_item_owned_0");

    $(selector, this.$el).attr("checked", "checked");
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
