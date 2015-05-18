Mamajamas.Views.ListItemSearchResult = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search_result'],

  tagName: 'li',

  initialize: function() {
  },

  events: {
    'click .add-to-list': 'selectItem',
    'click .product-image': 'doNothing',
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.updateRating("mamajamas_rating", ".detail-rating-mj", "egg");
    this.updateRating("rating", ".detail-rating-am", "star");
    return this;
  },

  selectItem: function(event) {
    event.preventDefault();
    this.trigger('search:product:selected', this.model);
    return false;
  },

  doNothing: function(event) {
    event.preventDefault();
    return false;
  },

  updateRating: function(ratingName, ratingContainerSelector, starClassName) {
    var itemRating = this.model.get(ratingName);
    if (itemRating) {
      itemRating = parseFloat(itemRating);
      var $stars = $("." + starClassName, $(ratingContainerSelector, this.$el));
      $($stars).each(function(idx, el) {
        var $star = $(el);
        var starRating = parseFloat($star.data("rating"));
        if (starRating > (itemRating + 0.5))
          return false;
        if (starRating <= itemRating)
          $star.addClass(starClassName + "-full");
        else if ((starRating - 0.5) <= itemRating) {
          $star.addClass(starClassName + "-half");
        }
      });
    }
  },

});
