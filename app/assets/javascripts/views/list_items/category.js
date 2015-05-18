Mamajamas.Views.ListItemCategory = Mamajamas.Views.ListItemDropdown.extend({

  tagName: "div",

  className: "cat-select",

  template: HandlebarsTemplates['list_items/category'],

  initialize: function() {},

  events: {
    "click .choicedrop a": "toggleList",
    "click .choicedrop ul li a": "selectCategory",
  },

  render: function() {
    this.$el.html(this.template({
      listItem: this.model.toJSON(),
      categories: Mamajamas.Context.Categories
    }));
    return this;
  },

  selectCategory: function(event) {
    var $target = $(event.currentTarget);
    var $categoryList = $target.parents("ul");
    var categoryId = $target.data("category-id");
    var categoryName = $target.html();

    this.model.set("category_id", categoryId);
    $categoryList.hide();
    this.render();
    $(".current-category", this.$el).html(categoryName);

    return false;
  }

});
