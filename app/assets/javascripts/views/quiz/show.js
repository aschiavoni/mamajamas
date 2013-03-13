Mamajamas.Views.QuizShow = Backbone.View.extend({

  initialize: function() {
    var question = new this.questions[0]();
    this.$el.html(question.render().$el);
  },

  events: {
  },

  questions: [
    Mamajamas.Views.QuizIntro
  ],

  render: function() {
    return this;
  },

});
