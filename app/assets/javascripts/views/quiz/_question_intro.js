Mamajamas.Views.QuizIntro = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/intro'],

  quizView: null,

  quizId: 'quiz01',

  large: true,

  events: {
    'click #bt-start': 'start'
  },

  start: function(event) {
    event.preventDefault();
    this.quizView.next();
    return false;
  },

});
