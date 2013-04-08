Mamajamas.Views.ListShow = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/show'],

  initialize: function() {
    this.indexView = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });

    // add-product-type is not contained in the view so we wire it up globally
    var _view = this;
    $("#add-product-type").click(function(event) {
      event.preventDefault();
      if (_view.isGuestUser()) {
        _view.unauthorized();
        return false;
      }
      return _view.addProductType(_view, event);
    });
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
    addItem.setup();
    return false;
  }

});
