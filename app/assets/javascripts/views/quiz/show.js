Mamajamas.Views.QuizShow = Backbone.View.extend({

  currentQuestion: 0,

  initialize: function() {
    this.renderCurrentQuestion();
  },

  events: {
  },

  questions: [
    Mamajamas.Views.QuizIntro,
    Mamajamas.Views.QuizBabyAge,
    Mamajamas.Views.QuizFeeding,
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
    this.$el.empty();
  },

  getQuestion: function(index) {
    var q = new this.questions[index]();
    q.quizView = this;
    return q;
  },

  renderCurrentQuestion: function() {
    var question = this.getQuestion(this.currentQuestion);
    this.$el.html(question.render().$el);
  },

});
