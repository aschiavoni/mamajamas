Mamajamas.Views.QuizFeeding = Mamajamas.Views.QuizMultiChoiceImageQuestion.extend({

  template: HandlebarsTemplates['quiz/feeding'],

  questionName: 'Feeding',

  initialize: function() {
    this.$el.attr("id", "quiz03");
    this.on('quiz:question:saved', this.next);
  }

});

