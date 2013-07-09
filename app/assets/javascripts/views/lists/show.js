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
      if (_view.isGuestUser()) {
        _view.unauthorized();
        return false;
      }

      // no-op if we are in the all category
      if (Mamajamas.Context.List.isAllCategory()) {
        return false;
      }

      return _view.addProductType(_view, event);
    });

    $('#bt-share').click(function(event) {
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

    // get suggestions
    var category = Mamajamas.Context.List.get('category');
    Mamajamas.Context.ProductTypeSuggestions.fetch({
      data: {
        category: category
      }
    });

    this.model.on('change:item_count', function() {
      var shareButton = $('#bt-share');
      if (this.model.get('item_count') > 0) {
        shareButton.removeClass('disabled');
      } else {
        shareButton.addClass('disabled');
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

    if (this.model.get('view_count') <= 1) {
      var helpModals = new Mamajamas.Views.ListHelpModals();
      $('body').append(helpModals.render().$el);
    }
    return this;
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
