Mamajamas.Views.ListItemRating = Backbone.View.extend({

  className: "stars",

  template: HandlebarsTemplates['list_items/rating'],

  readOnly: false,

  initialize: function() {
    this._ratingEnabled = false;
  },

  events: {
    "mouseenter": "enableRating",
    "mouseleave": "disableRating",
    "mouseenter .star": "highlight",
    "mouseleave .star": "unhighlight",
    "click .star": "rate"
  },

  render: function() {
    this.$el.html(this.template);
    this.restoreRating();
    return this;
  },

  rate: function(event) {
    if (this.readOnly)
      return true;
    var $star = $(event.target);
    var rating = parseInt($star.data("rating"));
    this.model.set("rating", rating);
  },

  enableRating: function(event) {
    this._ratingEnabled = true;
  },

  disableRating: function(event) {
    this._ratingEnabled = false;
    this.restoreRating();
  },

  restoreRating: function() {
    var rating = this.model.get("rating");
    if (rating) {
      $(".star", this.$el).each(function(idx, el) {
        var $star = $(el);
        if ($star.data("rating").toString() === rating.toString()) {
          $star.prevAll().andSelf().addClass("star-full");
          $star.nextAll().removeClass("star-full");
          return false;
        }
      });
    }
  },

  highlight: function(event) {
    if (!this._ratingEnabled || this.readOnly)
      return true;
    var $star = $(event.target);
    $star.prevAll().andSelf().addClass("star-full");
    $star.nextAll().removeClass("star-full");
  },

  unhighlight: function(event) {
    if (!this._ratingEnabled || this.readOnly)
      return true;
    var $star = $(event.target);
    $star.prevAll().andSelf().removeClass("star-full");
  }
});
