Mamajamas.Views.QuizShow = Backbone.View.extend({

  currentQuestion: 0,

  initialize: function() {
    this.renderCurrentQuestion();
    this.preloadImages();
  },

  events: {
  },

  questions: [

      [
        Mamajamas.Views.QuizIntro, new Mamajamas.Models.QuizQuestion()
      ],

      [
        Mamajamas.Views.QuizBabyAge, new Mamajamas.Models.QuizQuestion({
          answers: [
            "am expecting my first child.",
            false, // multiples
            null, // due date
            "0-3 mo" // age range
          ]
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

      [
        Mamajamas.Views.QuizTravel, new Mamajamas.Models.QuizQuestion()
      ],

      [
        Mamajamas.Views.QuizCaution, new Mamajamas.Models.QuizQuestion()
      ],

      [
        Mamajamas.Views.QuizZipCode, new Mamajamas.Models.QuizQuestion()
      ],

      [
        Mamajamas.Views.QuizCustomList, new Mamajamas.Models.QuizQuestion({
          answers: [ "false" ],
          complete_list: true
        })
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

  preloadImages: function() {
    var assetPath = Mamajamas.Context.AssetPath;
    var images = [
      assetPath + "quiz/q03a_breastfeed.jpg",
      assetPath + "quiz/q03b_pump.jpg",
      assetPath + "quiz/q03c_bottle.jpg",
      assetPath + "quiz/q04a_cloth.jpg",
      assetPath + "quiz/q04b_disposable.jpg",
      assetPath + "quiz/q05a_bassinet.jpg",
      assetPath + "quiz/q05b_crib.jpg",
      assetPath + "quiz/q05c_co-sleeping.jpg",
      assetPath + "quiz/q06a_homebody.jpg",
      assetPath + "quiz/q06b_jetsetter.jpg",
      assetPath + "quiz/q07a_mellow.jpg",
      assetPath + "quiz/q07b_cautious.jpg",
    ];

    $(images).each(function() {
      $("<img/>")[0].src = this;
    });
  },

});
