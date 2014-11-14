Mamajamas.Views.ListItemEdit = Mamajamas.Views.ListItem.extend({

  tagName: "div",

  template: HandlebarsTemplates["list_items/edit"],

  className: "prod prod-filled edit-mode choose-bt clearfix",

  oldModel: null,

  initialize: function() {
    BrowserDetect.init();

    var suffix = this.model.id == null ? "new" : this.model.id;
    this.model.set("idSuffix", suffix);

    _errMap = this.errorFieldMap();

    // save a clone of the original model in case we cancel
    this.oldModel = this.model.clone();

    this.model.on("change", this.updateMaybe, this);
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:age", this.updateAgeRange, this);
    this.model.on("change:owned", this.updateOwned, this);
    this.model.on("change:quantity", this.updateQuantity, this);
  },

  events: {
    "submit .new-list-item": "save",
    "click .cancel-item.button": "cancel",
    "click .find-item.button": "findItemClicked",
    "keyup textarea": "autoSaveNotes",
  },

  render: function() {
    var _view = this;

    this.$el.html(this.template(this.model.toJSON()));

    if (!Mamajamas.Context.User.is_facebook_connected || !this.model.isNew()) {
      $(".facebook-sharing", this.$el).remove();
    }

    // subviews
    var allowChange = Mamajamas.Context.List.get('category_id');
    var productTypeView = new Mamajamas.Views.ProductType({
      model: {
        listItem: this.model,
        list: Mamajamas.Context.List,
        allowChange: allowChange
      }
    });
    $('.prod-category', this.$el).prepend(productTypeView.render().$el);

    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("div.rating", this.$el).append(ratingView.render().$el);

    var ageRangeView = new Mamajamas.Views.ListItemAgeRange({
      model: this.model
    });
    $(".prod-when-own fieldset", this.$el).append(ageRangeView.render().$el);

    var quantityView = new Mamajamas.Views.ListItemQuantity({
      model: this.model
    });
    $(".prod-when-own fieldset", this.$el).append(quantityView.render().$el);

    this.initializeAutocomplete();

    this.$itemPicture = $(".prod-thumb > img", this.$el);
    this.$itemPictureProgress = $(".progress-container img.progress", this.$el);
    this.initializeItemPictureUploads();

    _.defer(function() {
      _view.inFieldLabels();
      // the following is a bit of hack to trigger display of inFieldLabels
      // it would be great to lose the inFieldLabels dependency
      var linkVal = _view.itemField("link").val();
      var priceVal = _view.itemField("price").val();
      if (_view.model.isNew() && (!linkVal || linkVal.trim().length == 0)) {
        _view.itemField("link").val(null);
        _view.itemField("link").focus();
      }
      if (_view.model.isNew() || (!priceVal || priceVal.trim().length == 0)) {
        _view.itemField("price").val("$0.00");
      }
      _view.itemField("name").focus();
    });

    if (this.ie9orLower()) {
      $(".list-item-image-file", this.$el).show();
      $(".bt-thumb-upload", this.$el).remove();
    }

    if (this.model.get('show_chooser'))
      this.findItem(this);

    return this;
  },

  inFieldLabels: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  itemForm: function() {
    return $(".new-list-item", this.$el);
  },

  itemId: function(name) {
    return "#list_item_" + name + "_" + this.model.get("idSuffix");
  },

  itemField: function(name) {
    var itemId = this.itemId(name);
    return $(itemId, this.$el);
  },

  updateRating: function() {
    this.itemField("rating").val(this.model.get("rating"));
  },

  updateAgeRange: function() {
    this.itemField("age").val(this.model.get("age"));
  },

  updateOwned: function() {
    this.itemField("owned").val(this.model.get("owned"));
  },

  updateQuantity: function() {
    this.itemField("quantity").val(this.model.get("quantity"));
  },

  initializeAutocomplete: function() {
    var _view = this;
    var url = '/api/products/';

    _view.itemField("name").autocomplete({
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
        _view.itemField("link").val(ui.item.value.url);
        _view.itemField("image_url").val(ui.item.value.image_url);
        _view.inFieldLabels();
        return false;
      }
    }).data('ui-autocomplete')._renderItem = function(ul, item) {
      return $("<li class=\"ui-menu-item\" role=\"presentation\">").
        append("<a class=\"ui-corner-all\" tabindex=\"-1\" title=\"" + Mamajamas.Utils.htmlEscape(item.name)+ "\"'>" + item.label + "</a>").
        appendTo(ul);
    };
  },

  doSave: function(attributes, createHandler, updateHandler) {
    var _view = this;
    _view.clearErrors();

    if (_view.model.isNew()) {
      // creating a new list item
      _view.model = Mamajamas.Context.ListItems.create(attributes, {
        wait: true,
        success: function() {
          if (createHandler)
            createHandler();
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
          if (updateHandler)
            updateHandler();
        },
        error: function(model, response) {
          _view.handleError(model, response);
        }
      });
    }
  },

  save: function(event) {
    if (event)
      event.preventDefault();

    var _view = this;
    this.setCurrentPosition();

    var attributes = {
      name: this.itemField("name").val(),
      link: this.itemField("link").val(),
      notes: this.itemField("edit_notes").val(),
      product_type_id: this.itemField("product_type_id").val(),
      product_type: _view.model.get("product_type"),
      product_type_name: _view.model.get("product_type_name"),
      category_id: this.itemField("category_id").val(),
      priority: this.itemField("priority").val(),
      age: this.itemField("age").val(),
      rating: this.itemField("rating").val(),
      image_url: this.itemField("image_url").val(),
      owned: _view.model.get("owned"),
      placeholder: false,
      price: _view.itemField("price").val(),
      vendor_id: this.itemField("vendor_id").val(),
      vendor: this.itemField("vendor").val(),
      list_item_image_id: this.itemField('list_item_image_id').val(),
      idSuffix: _view.model.get("idSuffix"),
    };

    this.doSave(attributes, function() {
      _view.$el.remove();
      if (_view.options.parent)
        _view.options.parent.remove();
      if (_view.shouldShareOnFacebook())
        _view.shareOnFacebook();
    }, function() {
      _view.$el.remove();
      if (_view.options.parent) {
        _view.options.parent.render();
        _view.options.parent.editing = false;
        _view.options.parent.$el.show();
      }
    });
    Mamajamas.Context.ListItems.clearPlaceholders(
      this.model.get('product_type_id'),
      this.model.get('product_type_name'));

    return false;
  },

  autoSaveNotes: function(event) {
    var _view = this;
    var attributes = {
      notes: this.itemField("edit_notes").val()
    }
    if (!_view.model.isNew()) {
      _view.autoSave(_view, attributes);
    }
    return true;
  },

  autoSave: _.debounce(function(_view, attributes) {
    _view.doSave(attributes, null, null);
  }, 3000, false),

  updateMaybe: function() {
    var requiresUpdateAttribs = [ 'name', 'link', 'image_url', 'vendor_id' ];
    var changedAttribs = _.keys(this.model.changed);
    var needsUpdate = _.any(changedAttribs, function(attrib) {
      return _.contains(requiresUpdateAttribs, attrib);
    });
    if (needsUpdate)
      this.update();
  },

  update: function() {
    this.$itemPicture.attr("src", this.model.get("image_url"));

    this.itemField("name").val(this.model.get("name"));
    this.itemField("link").val(this.model.get("link"));
    this.itemField("image_url").val(this.model.get("image_url"));
    this.itemField("vendor").val(this.model.get("vendor"));
    this.itemField("vendor_id").val(this.model.get("vendor_id"));
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

    // notes might have auto-saved - let's revert
    if (this.model.get("notes") != this.itemField("edit_notes").val()) {
      var attributes = {
        notes: this.model.get("notes")
      }
      this.doSave(attributes, null, null);
    }

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
    var _view = this;
    return {
      name: this.itemId("name"),
      link: this.itemId("link"),
      notes: this.itemId("edit_notes"),
    };
  },

  initializeItemPictureUploads: function() {
    var _view = this;

    $(".bt-thumb-upload, .prod-thumb", this.$el).click(function(event) {
      event.preventDefault();
      _view.itemField("image_image").trigger("click");
    });

    this.itemField("image_image").fileupload({
      url: '/api/list_item_images',
      type: 'POST',
      dropZone: _view.$itemPicture,
      pasteZone: _view.$itemPicture,
      maxNumberOfFiles: 1,
      start: function(e) {
        _view.itemForm().progressIndicator("show");
      },
      stop: function(e) {
        setTimeout(function() {
          _view.itemForm().progressIndicator("hide");
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
        _view.itemField('list_item_image_id').val(listItem.id)
        _view.itemField('image_url').val(listItem.image.url);
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
    search.show();
  },

  findItemClicked: function(event) {
    event.preventDefault();
    this.findItem(this);
    return false;
  },

  ie9orLower: function() {
    return (BrowserDetect.browser == 'Explorer' && BrowserDetect.version <= 9);
  },

  showAddedModal: function(addedView) {
    // no-op - interface implementation for any item view
    // ListItemsIndex.insertItem may call this
  },

});
