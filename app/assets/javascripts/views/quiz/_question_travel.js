Mamajamas.Views.QuizTravel = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/travel'],

  quizView: null,

  questionName: 'Travel',

  steps: [ -21, 41, 105, 166, 229 ],

  initialize: function() {
    this.$el.attr('id', 'quiz06');
    this.on('quiz:question:rendered', this.rendered, this);
    this.on('quiz:question:saving', this.saving, this);
    this.on('quiz:question:saved', this.next, this);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click .skip': 'skip',
  },

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
  }

});
