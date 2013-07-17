Mamajamas.Views.QuizBabyAge = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/baby_age'],

  initialize: function() {
    this.$el.attr('id', 'quiz02');
    this.$el.addClass('large');
    this.kid = new Mamajamas.Models.Kid();
    this.kid.set('age_range', 'Pre-birth');
    this.on('quiz:baby_age:saved', this.next);
  },

  events: {
    'click .bt-close': 'closeQuiz',
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click #mom-type': 'showMomTypes',
    'click .mom-type': 'selectMomType',
    'click #baby-age': 'showBabyAges',
    'click .baby-age': 'selectBabyAge',
  },

  render: function() {
    var $questionView = $(this.template(this.model.toJSON()));
    if (this.model.get('answers')[0] != 'a mom to be.') {
      $('#q02-02', $questionView).show();
    }
    this.$el.html($questionView);
    return this;
  },

  previous: function(event) {
    event.preventDefault();
    this.quizView.previous();
    return false;
  },

  next: function() {
    this.quizView.next();
  },

  showMomTypes: function(event) {
    event.preventDefault();

    var answerList = $(event.target, this.$el).parents('a').siblings('ol');
    answerList.css('width', '8em');
    answerList.show();

    return false;
  },

  selectMomType: function(event) {
    event.preventDefault();

    var answer = $(event.target, this.$el);
    var answerList = answer.parents('ol');
    answerList.css('width', null);
    answerList.hide();

    var answerText = answer.html();
    $('#mom-type-desc', this.$el).html(answerText);

    var answers = this.model.get('answers');
    answers[0] = answerText;
    if (answerText == 'a mom to be.') {
      this.kid.set('age_range', 'Pre-birth');
      this.hideBabyAgeQuestion();
    } else {
      answers[1] = '0-3 mo';
      this.kid.set('age_range', '0-3 mo');
      this.showBabyAgeQuestion();
    }

    this.model.set('answers', answers);

    return false;
  },

  showBabyAgeQuestion: function() {
    $('#q02-02', this.$el).show();
  },

  hideBabyAgeQuestion: function() {
    $('#q02-02', this.$el).hide();
  },

  showBabyAges: function(event) {
    event.preventDefault();

    var answerList = $(event.target, this.$el).parents('a').siblings('ol');
    answerList.css('width', '5.5em');
    answerList.css('max-height', '4.5em');
    answerList.css('overflow', 'auto');
    answerList.show();

    return false;
  },

  selectBabyAge: function() {
    event.preventDefault();

    var answer = $(event.target, this.$el);
    var answerList = answer.parents('ol');
    answerList.css('width', null);
    answerList.css('max-height', null);
    answerList.css('overflow', null);
    answerList.hide();

    var answerText = answer.html();
    $('#baby-age-desc', this.$el).html(answerText);
    this.kid.set('age_range', answerText.replace('.', ''));
    var answers = this.model.get('answers');
    answers[1] = answerText;
    this.model.set('answers', answers);

    return false;
  },

  save: function(event) {
    event.preventDefault();

    Mamajamas.Context.Progress.show();
    var _view = this;
    Mamajamas.Context.Kids.create({
      kid: {
        age_range_name: this.kid.get('age_range')
      }
    }, {
      wait: true,
      success: function(model) {
        _view.trigger('quiz:baby_age:saved');
      },
      error: function(model, response) {
        Mamajamas.Context.Notifications.error('Please try again later.');
      },
      complete: function() {
        Mamajamas.Context.Progress.hide();
      }
    });

    return false;
  },

})
