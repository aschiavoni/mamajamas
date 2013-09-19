Mamajamas.Views.ListItemEdit = Mamajamas.Views.Base.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/edit'],

  className: "prod prod-filled edit-mode choose-bt",

  oldModel: null,

  initialize: function() {
    BrowserDetect.init();
    _errMap = this.errorFieldMap();

    // save a clone of the original model in case we cancel
    this.oldModel = this.model.clone();

    this.model.on("change", this.renderMaybe, this);
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:age", this.updateAgeRange, this);
    this.model.on("change:priority", this.updatePriority, this);
  },

  events: {
    "submit .new-list-item": "save",
    "change input[name='list_item[owned]']": "toggleOwnedCheckbox",
    "change .owned-cb": "toggleOwnedRadioButtons",
    "click .cancel-item.button": "cancel",
    "click .find-item.button": "findItemClicked",
  },

  renderMaybe: function() {
    var requiresRenderAttribs = [ 'name', 'link', 'image_url', 'vendor_id' ];
    var changedAttribs = _.keys(this.model.changed);
    var needsRender = _.any(changedAttribs, function(attrib) {
      return _.contains(requiresRenderAttribs, attrib);
    });
    if (needsRender)
      this.render();
  },

  render: function() {
    var _view = this;

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

    this.$form = $(".new-list-item", this.$el);
    this.$itemPicture = $(".prod-thumb > img", this.$el);
    this.$itemPictureProgress = $(".progress-container img.progress", this.$el);
    this.initializeItemPictureUploads();

    _.defer(function() {
      $("label", _view.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#list_item_name", _view.$el).focus();
    });

    if (this.ie9orLower()) {
      $(".list-item-image-file", this.$el).show();
      $(".bt-thumb-upload", this.$el).remove();
    }

    if (this.model.get('show_chooser'))
      this.findItem(this);

    return this;
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
    var url = '/api/products/';

    $("#list_item_name", this.$el).autocomplete({
      delay: 500,
      source: function(request, response) {
        $.getJSON(url, { filter: request.term }, function(data) {
          response($.map(data, function(item) {
            return {
              label: item.display_name,
              name: item.name,
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
    }).data('ui-autocomplete')._renderItem = function(ul, item) {
      return $("<li class=\"ui-menu-item\" role=\"presentation\">").
        append("<a class=\"ui-corner-all\" tabindex=\"-1\" title=\"" + Mamajamas.Utils.htmlEscape(item.name)+ "\"'>" + item.label + "</a>").
        appendTo(ul);
    };
  },

  save: function(event) {
    if (event)
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
      placeholder: false,
      vendor_id: $("#list_item_vendor_id", this.$el).val(),
      vendor: $("#list_item_vendor", this.$el).val(),
      list_item_image_id: $('#list_item_list_item_image_id', this.$el).val()
    };

    if (_view.model.isNew()) {
      // creating a new list item
      _view.model = Mamajamas.Context.ListItems.create(attributes, {
        wait: true,
        success: function() {
          _view.$el.remove();
          if (_view.options.parent)
            _view.options.parent.remove();
          if (_view.shouldShareOnFacebook())
            _view.shareOnFacebook();
          var currentItemCount = Mamajamas.Context.List.get('item_count');
          Mamajamas.Context.List.set('item_count', currentItemCount + 1);
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
          if (_view.options.parent) {
            _view.options.parent.render();
            _view.options.parent.editing = false;
            _view.options.parent.$el.show();
          }
        },
        error: function(model, response) {
          _view.handleError(model, response);
        }
      });
    }

    Mamajamas.Context.ListItems.clearPlaceholders(_view.model.get('product_type_id'));
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
    this.model.set(this.oldModel.attributes);
    if (this.options.parent) {
      this.options.parent.$el.show();
      this.options.parent.editing = false;
    }
    this.$el.remove();
    return true;
  },

  toggleOwnedCheckbox: function(event) {
    var owned = $("input[name='list_item[owned]']:checked", this.$el).val() == "1";
    $("td.own input[type='checkbox']", this.$el).prop("checked", owned);
  },

  toggleOwnedRadioButtons: function(event) {
    var owned = $(event.target).is(":checked");
    var selector;
    if (owned)
      selector = $(".owned-rb", this.$el);
    else
      selector = $(".need-rb", this.$el);

    $(selector, this.$el).prop("checked", true);
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
      name: '#list_item_name',
      link: '#list_item_link',
      notes: '#list_item_notes',
    };
  },

  initializeItemPictureUploads: function() {
    var _view = this;

    $(".bt-thumb-upload, .prod-thumb", this.$el).click(function(event) {
      event.preventDefault();
      $("#list_item_image_image", _view.$el).trigger("click");
    });

    $("#list_item_image_image", this.$el).fileupload({
      url: '/api/list_item_images',
      type: 'POST',
      dropZone: _view.$itemPicture,
      pasteZone: _view.$itemPicture,
      maxNumberOfFiles: 1,
      start: function(e) {
        _view.$form.progressIndicator("show");
      },
      stop: function(e) {
        setTimeout(function() {
          _view.$form.progressIndicator("hide");
        }, 600);
      },
      add: function(e, data) {
        var types = /(\.|\/)(gif|jpe?g|png)$/i;
        var file = data.files[0];
        if (types.test(file.type) || types.test(file.name)) {
          data.submit();
        } else {
          Mamajamas.Context.Notifications.error(file.name + " does not appear to be an image file.");
        }
      },
      done: function(e, data) {
        var listItem = null;
        if (_view.ie9orLower()) {
          var result = $( 'pre', data.result  ).text();
          listItem = $.parseJSON(result);
        } else {
          listItem = $.parseJSON(data.result);
        }
        $('#list_item_list_item_image_id', _view.$el).val(listItem.id)
        $('#list_item_image_url', _view.$el).val(listItem.image.url);
        _view.$itemPicture.attr("src", listItem.image.url);
      }
    });
  },

  findItem: function(_view) {
    _view.model.set('show_chooser', false);
    var search = new Mamajamas.Views.ListItemSearch({
      model: _view.model
    });
    $('#buildlist').after(search.render().$el);
  },

  findItemClicked: function(event) {
    event.preventDefault();
    this.findItem(this);
    return false;
  },

  ie9orLower: function() {
    return (BrowserDetect.browser == 'Explorer' && BrowserDetect.version <= 9);
  },

});
