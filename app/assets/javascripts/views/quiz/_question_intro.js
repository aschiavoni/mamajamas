Mamajamas.Views.QuizIntro = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/intro'],

  quizView: null,

  initialize: function() {
    this.$el.attr("id", "quiz01");
    this.$el.addClass("large");
  },

  events: {
    'click #bt-start': 'start'
  },

  start: function(event) {
    event.preventDefault();
    this.quizView.next();
    return false;
  },

});
