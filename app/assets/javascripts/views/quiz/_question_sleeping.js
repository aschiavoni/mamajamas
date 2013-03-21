Mamajamas.Views.QuizSleeping = Mamajamas.Views.QuizMultiChoiceImageQuestion.extend({

  template: HandlebarsTemplates['quiz/sleeping'],

  questionName: 'Sleeping',

  initialize: function() {
    this.$el.attr("id", "quiz05");
    this.on('quiz:question:saved', this.next);
  }

});
