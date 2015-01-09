Mamajamas.Views.RecommendationsEmpty = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates["recommendations/empty"],

  initialize: function() {
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template());
    return this;
  }
});
