Mamajamas.Views.QuizIntro = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/intro'],

  initialize: function() {
    this.$el.attr("id", "quiz01");
  },

  events: {
    'click #bt-start': 'start'
  },

  start: function(event) {
    event.preventDefault();
    return false;
  },

});
