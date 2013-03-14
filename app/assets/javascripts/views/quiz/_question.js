Mamajamas.Views.QuizQuestion = Backbone.View.extend({

  className: 'quiz-box',

  initialize: function() {
  },

  render: function() {
    this.$el.html(this.template());
    return this;
  },

});
