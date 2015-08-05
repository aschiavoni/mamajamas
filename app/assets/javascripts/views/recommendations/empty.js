Mamajamas.Views.RecommendationsEmpty = Mamajamas.Views.Base.extend({

  className: 'loading',

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
