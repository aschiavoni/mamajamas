Mamajamas.Views.ListShow = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/show'],

  initialize: function() {
    this.indexView = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });

    var _view = this;

    // add-product-type is not contained in the view so we wire it up globally
    // hide the new item button if we are in the all category
    if (Mamajamas.Context.List.isAllCategory())
      $("#add-product-type").hide();

    $("#add-product-type").click(function(event) {
      event.preventDefault();

      // no-op if we are in the all category
      if (Mamajamas.Context.List.isAllCategory()) {
        return false;
      }

      return _view.addProductType(_view, event);
    });

    $('#bt-share, #bt-share-header').click(function(event) {
      if (Mamajamas.Context.List.get('item_count') == 0) {
        event.preventDefault();
        return false;
      }

      if (_view.isGuestUser()) {
        _view.unauthorized();
        return false;
      }
      return true;
    });

    $('#find-moms').click(function(event) {
      if (_view.isGuestUser()) {
        _view.unauthorized();
        return false
      }
      return true;
    });

    this.model.on('change:item_count', function() {
      var shareButton = $('#bt-share');
      var shareButonHeader = $('#bt-share-header');
      if (this.model.get('item_count') > 0) {
        shareButton.removeClass('disabled');
        shareButonHeader.attr('href', "/profile")
      } else {
        shareButton.addClass('disabled');
        shareButonHeader.attr('href', "/list")
      }
    }, this)
  },

  events: {
    "click #babygear th.own": "sort",
    "click #babygear th.item": "sort",
    "click #babygear th.rating": "sort",
    "click #babygear th.when": "sort",
    "click #babygear th.priority": "sort"
  },

  render: function() {
    this.$el.html(this.template);
    $("table#babygear", this.$el).append(this.indexView.render().$el);

    if (this.model.get('view_count') == 0) {
      var helpModals = new Mamajamas.Views.ListHelpModals();
      $('body').append(helpModals.render().$el).addClass("list-help");
    }

    if ($("#add-list-item").length > 0)
      _.defer(this.addToMyList, this);

    return this;
  },

  addToMyList: function(_view) {
    $.cookies.set("add_to_my_list", null);
    var listItemAttrs = $("#add-list-item").data("add-list-item");
    var editView = new Mamajamas.Views.ListItemEdit({
      model: new Mamajamas.Models.ListItem(listItemAttrs)
    });
    $("#list-items").prepend(editView.render().$el);
  },

  sort: function(event) {
    $("#babygear th").removeClass("sorting");
    var $header = $(event.target);
    $header.addClass("sorting");
    return this.indexView.sort(event);
  },

  addProductType: function(view, event) {
    var addItem = new Mamajamas.Views.ListItemNew({
      model: new Mamajamas.Models.ListItem({
        category_id: view.model.get("category_id"),
        age: "Pre-birth",
        priority: 2,
        image_url: "/assets/products/icons/unknown.png"
      })
    });

    $("#list-items").prepend(addItem.render().$el);
    return false;
  }

});
