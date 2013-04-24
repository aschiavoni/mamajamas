Mamajamas.Views.QuizQuestion = Backbone.View.extend({

  className: 'quiz-box',

  questionName: '',

  quizView: null,

  large: false,

  initialize: function() {
    this.$el.attr("id", this.quizId);
    if (this.large)
      this.$el.addClass("large");
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.trigger('quiz:question:rendered');
    return this;
  },

  closeQuiz: function(event) {
    event.preventDefault();
    if (confirm("Are you sure you want to quit the quiz?")) {
      window.location = '/';
    }
    return false;
  },

  previous: function(event) {
    event.preventDefault();
    this.quizView.previous();
    return false;
  },

  next: function() {
    this.quizView.next();
  },

  skip: function(event) {
    event.preventDefault();
    this.next();
    return false;
  },

  save: function(event) {
    event.preventDefault();
    this.trigger('quiz:question:saving');

    var _view = this;

    $.ajax({
      url: '/quiz',
      type: 'PUT',
      data: {
        question: _view.questionName,
        answers: _view.model.get('answers')
      },
      success: function(data, status, xhr) {
        _view.trigger('quiz:question:saved');
      },
      error: function(xhr, status, error) {
        Mamajamas.Context.Notifications.error('Please try again later.');
      }
    });

    return false;
  },

});

Mamajamas.Views.QuizMultiChoiceImageQuestion = Mamajamas.Views.QuizQuestion.extend({

  initialize: function() {
    this.$el.attr('id', this.quizId);
    this.on('quiz:question:saved', this.next);
  },

  selectedClass: 'q-selected',

  events: {
    'click .bt-close': 'closeQuiz',
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click .skip': 'skip',
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

    this.trigger('quiz:question:rendered');
    return this;
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

Mamajamas.Views.QuizSliderQuestion = Mamajamas.Views.QuizQuestion.extend({

  initialize: function() {
    this.$el.attr('id', this.quizId);
    this.on('quiz:question:rendered', this.rendered, this);
    this.on('quiz:question:saving', this.saving, this);
    this.on('quiz:question:saved', this.next, this);
  },

  events: {
    'click .bt-close': 'closeQuiz',
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click .skip': 'skip',
    'click #q-sliderscale': 'moveToCursor',
    'click .q-slider a:first': 'moveToLeft',
    'click .q-slider a:last': 'moveToRight',
  },

  steps: [ -21, 41, 105, 166, 229 ],

  rendered: function() {
    var _view = this;
    this.$sliderArrow = $('#q-sliderarrow', this.$el);

    this.$sliderArrow.draggable({
      axis: "x",
      // grid: [63, 0],
      drag: function(event, ui) {
        if (ui.position.left < _view.minLeft())
          ui.position.left = _view.minLeft();
        else if (ui.position.left > _view.maxLeft())
          ui.position.left = _view.maxLeft();
      }
    });
  },

  moveToCursor: function(event) {
    var target = $(event.currentTarget);
    var x = event.pageX - target.offset().left - 24;

    if (x < this.minLeft())
      x = this.minLeft();
    else if (x > this.maxLeft())
      x = this.maxLeft();

    this.moveTo(x);
    return true;
  },

  moveToLeft: function(event) {
    event.preventDefault();
    this.moveTo(this.minLeft());
    return false;
  },

  moveToRight: function(event) {
    event.preventDefault();
    this.moveTo(this.maxLeft());
    return false;
  },

  moveTo: function(x) {
    this.$sliderArrow.animate({ left: x }, 100, 'linear');
  },

  saving: function() {
    var sliderPosition = this.$sliderArrow.position().left;
    this.calculateAnswer(sliderPosition);
  },

  minLeft: function() {
    return this.steps[0];
  },

  maxLeft: function() {
    return this.steps[this.steps.length - 1];
  },

  calculateAnswer: function(left) {
    var answer = 0;
    for (var i = 0; i < this.steps.length; i += 1) {
      answer += 1;
      var diff = this.steps[i + 1] - this.steps[i];
      var midway = this.steps[i] + (diff / 2);
      if (left < midway && left < this.steps[i + 1]) {
        break;
      }
    }
    this.model.set('answers', [ answer ]);
    return answer;
  },

});
