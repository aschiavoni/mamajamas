Mamajamas.Views.ListItemRating = Backbone.View.extend({

  className: "eggs",

  template: HandlebarsTemplates['list_items/rating'],

  initialize: function() {
    this._ratingEnabled = false;
  },

  events: {
    "mouseenter": "enableRating",
    "mouseleave": "disableRating",
    "mouseenter .egg": "highlight",
    "mouseleave .egg": "unhighlight",
    "click .egg": "rate"
  },

  render: function() {
    this.$el.html(this.template);
    this.restoreRating();
    return this;
  },

  rate: function(event) {
    var $egg = $(event.target);
    var rating = parseInt($egg.data("rating"));
    this.model.set("rating", rating);
    this.model.save();
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
    $(".egg", this.$el).each(function(idx, el) {
      var $egg = $(el);
      if ($egg.data("rating") === rating) {
        $egg.prevAll().andSelf().addClass("egg-full");
        $egg.nextAll().removeClass("egg-full");
        return false;
      }
    });
  },

  highlight: function(event) {
    if (!this._ratingEnabled)
      return true;
    var $egg = $(event.target);
    $egg.prevAll().andSelf().addClass("egg-full");
    $egg.nextAll().removeClass("egg-full");
  },

  unhighlight: function(event) {
    if (!this._ratingEnabled)
      return true;
    var $egg = $(event.target);
    $egg.prevAll().andSelf().removeClass("egg-full");
  }
});
