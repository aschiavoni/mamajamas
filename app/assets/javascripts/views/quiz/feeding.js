Mamajamas.Views.QuizFeeding = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/feeding'],

  quizView: null,

  selectedClass: 'q-selected',

  initialize: function() {
    this.$el.attr("id", "quiz03");
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'next',
    'click .skip': 'next',
    'click .q-multi a': 'toggleSelected'
  },

  render: function() {
    var $questionView = $(this.template(this.model.toJSON()));

    var answers = this.model.get('answers');

    var _view = this;
    $('ol.q-multi li', $questionView).each(function(idx) {
      var $answerLi = $(this);
      var answerText = $('strong', $answerLi).html();
      if (answers.indexOf(answerText) > -1) {
        $answerLi.addClass(_view.selectedClass);
      }
    });

    this.$el.html($questionView);
    this.highlightNextMaybe();

    return this;
  },

  previous: function(event) {
    event.preventDefault();
    this.quizView.previous();
    return false;
  },

  next: function(event) {
    event.preventDefault();
    this.quizView.next();
    return false;
  },

  toggleSelected: function(event) {
    event.preventDefault();

    var $answer = $(event.target, this.$el).parents('li');
    if ($answer.hasClass(this.selectedClass))
      $answer.removeClass(this.selectedClass);
    else
      $answer.addClass(this.selectedClass);

    this.highlightNextMaybe();
    this.setAnswers();

    return false;
  },

  setAnswers: function() {
    var answers = [];
    $('ol.q-multi li.' + this.selectedClass, this.$el).each(function(idx) {
      var $answerLi = $(this);
      var answerText = $('strong', $answerLi).html();
      answers.push(answerText);
    });

    this.model.set('answers', answers);
  },

  highlightNextMaybe: function() {
    if ($('ol.q-multi li.' + this.selectedClass, this.$el).length > 0) {
      $('#bt-next', this.$el).addClass('bt-color');
    } else {
      $('#bt-next', this.$el).removeClass('bt-color');
    }
  }

});

