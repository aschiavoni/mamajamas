Mamajamas.Views.QuizDiapering = Mamajamas.Views.QuizMultiChoiceImageQuestion.extend({

  template: HandlebarsTemplates['quiz/diapering'],

  questionName: 'Diapering',

  initialize: function() {
    this.$el.attr("id", "quiz04");
    this.on('quiz:question:saved', this.next);
  }

});
