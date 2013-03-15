Mamajamas.Views.QuizBabyAge = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/baby_age'],

  quizView: null,

  initialize: function() {
    this.$el.attr('id', 'quiz02');
    this.$el.addClass('large');
    this.model = new Mamajamas.Models.Kid();
    this.model.set('age_range', 'Pre-birth');
    this.on('quiz:baby_age:saved', this.next);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click #mom-type': 'showMomTypes',
    'click .mom-type': 'selectMomType',
    'click #baby-age': 'showBabyAges',
    'click .baby-age': 'selectBabyAge',
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

    var answers = $(event.target, this.$el).parents('a').siblings('ol');
    answers.css('width', '8em');
    answers.show();

    return false;
  },

  selectMomType: function(event) {
    event.preventDefault();

    var answer = $(event.target, this.$el);
    var answers = answer.parents('ol');
    answers.css('width', null);
    answers.hide();

    var answerText = answer.html();
    $('#mom-type-desc', this.$el).html(answerText);

    if (answerText == 'a mom to be') {
      this.model.set('age_range', 'Pre-birth');
      this.hideBabyAgeQuestion();
    } else {
      this.model.set('age_range', '0-3 mo');
      this.showBabyAgeQuestion();
    }

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

    var answers = $(event.target, this.$el).parents('a').siblings('ol');
    answers.css('width', '5.5em');
    answers.css('max-height', '4.5em');
    answers.css('overflow', 'auto');
    answers.show();

    return false;
  },

  selectBabyAge: function() {
    event.preventDefault();

    var answer = $(event.target, this.$el);
    var answers = answer.parents('ol');
    answers.css('width', null);
    answers.css('max-height', null);
    answers.css('overflow', null);
    answers.hide();

    var answerText = answer.html();
    $('#baby-age-desc', this.$el).html(answerText);
    this.model.set('age_range', answerText.replace('.', ''));

    return false;
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    Mamajamas.Context.Kids.create({
      kid: {
        age_range_name: this.model.get('age_range')
      }
    }, {
      wait: true,
      success: function(model) {
        _view.trigger('quiz:baby_age:saved');
      },
      error: function(model, response) {
        Mamajamas.Context.Notifications.error('Please try again later.');
      }
    });

    return false;
  },

})
