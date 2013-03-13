Mamajamas.Views.QuizShow = Backbone.View.extend({

  initialize: function() {
    var introQuestion = new Mamajamas.Views.QuizQuestion();
    this.$el.html(introQuestion.render().$el);
  },

  events: {
  },

  render: function() {
    return this;
  },

});
