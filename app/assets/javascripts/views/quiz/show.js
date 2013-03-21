Mamajamas.Views.QuizShow = Backbone.View.extend({

  currentQuestion: 0,

  initialize: function() {
    this.renderCurrentQuestion();
  },

  events: {
  },

  questions: [
    [
      Mamajamas.Views.QuizIntro, new Mamajamas.Models.QuizQuestion()
    ],

    [
      Mamajamas.Views.QuizBabyAge, new Mamajamas.Models.QuizQuestion({
        answers: [ 'a mom to be.', '0-3 mo' ]
      })
    ],

    [
      Mamajamas.Views.QuizFeeding, new Mamajamas.Models.QuizQuestion()
    ],

    [
      Mamajamas.Views.QuizDiapering, new Mamajamas.Models.QuizQuestion()
    ],

    [
      Mamajamas.Views.QuizSleeping, new Mamajamas.Models.QuizQuestion()
    ],
  ],

  render: function() {
    return this;
  },

  next: function() {
    this.currentQuestion++;
    if (this.currentQuestion > this.questions.length - 1) {
      this.currentQuestion = this.questions.length - 1;
      this.done();
    } else {
      this.renderCurrentQuestion();
    }
  },

  previous: function() {
    this.currentQuestion--;
    if (this.currentQuestion < 0) this.currentQuestion = 0;
    this.renderCurrentQuestion();
  },

  done: function() {
    window.location = '/list';
  },

  getQuestion: function(index) {
    var q = this.questions[index];
    var question = new q[0]({
      model: q[1]
    });
    question.quizView = this;
    return question;
  },

  renderCurrentQuestion: function() {
    var question = this.getQuestion(this.currentQuestion);
    this.$el.html(question.render().$el);
  },

});
