Mamajamas.Views.QuizBabyAge = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/baby_age'],

  questionName: 'Age',

  initialize: function() {
    this.$el.attr('id', 'quiz02');
    this.$el.addClass('large');
    this.kid = new Mamajamas.Models.Kid({
      age_range: 'Pre-birth',
      due_date: null,
      multiples: false,
    });
    this.on('quiz:question:saved', this.next);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'saveKid',
    'click #mom-type': 'showMomTypes',
    'click .mom-type': 'selectMomType',
    'click #baby-age': 'showBabyAges',
    'click .baby-age': 'selectBabyAge',
    'change input[name=twins]': "toggleMultiples",
    'click .skip': "skipQuiz",
  },

  render: function() {
    var _view = this;
    var $questionView = $(this.template(this.model.toJSON()));
    var answerText = this.model.get("answers")[0];
    _.defer(function () { _view.initQuestion(answerText) });
    this.$el.html($questionView);

    return this;
  },

  previous: function(event) {
    event.preventDefault();
    this.quizView.previous();
    return false;
  },

  next: function() {
    if (this.model.get("skipped") == true)
      window.location = "/list";
    else if (this.justBrowsing()) {
      this.quizView.goTo(8);
    }
    else
      this.quizView.next();
  },

  skipQuiz: function(event) {
    event.preventDefault();
    this.model.set("answers", []);
    this.model.set("complete_list", true);
    this.model.set("skipped", true);
    this.save(event);
    return false;
  },

  initQuestion: function(answerText) {
    switch (answerText) {
    case "I'm expecting my first child.":
      this.hideBabyAgeQuestion();
      this.showDueDateQuestion();
      this.showTwinsQuestion();
      break;
    case "I'm already a parent.":
      this.showBabyAgeQuestion();
      this.hideDueDateQuestion();
      this.showTwinsQuestion();
      break;
    case "I'm already a parent and expecting again.":
      this.showBabyAgeQuestion();
      this.showDueDateQuestion();
      this.showTwinsQuestion();
      break;
    case "I'm just browsing or have advice.":
      this.hideBabyAgeQuestion();
      this.hideDueDateQuestion();
      this.hideTwinsQuestion();
      break;
    }
  },

  showMomTypes: function(event) {
    event.preventDefault();

    var answerList = $(event.target, this.$el).parents('a').siblings('ol');
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
    switch (answerText) {
      case "I'm expecting my first child.":
        this.kid.set('age_range', 'Pre-birth');
        this.hideBabyAgeQuestion();
        this.showDueDateQuestion();
        this.showTwinsQuestion();
        break;
      case "I'm already a parent.":
        answers[3] = '0-3 mo';
        this.kid.set('age_range', '0-3 mo');
        this.showBabyAgeQuestion();
        this.hideDueDateQuestion();
        this.showTwinsQuestion();
        break;
      case "I'm already a parent and expecting again.":
        answers[3] = '0-3 mo';
        this.kid.set('age_range', '0-3 mo');
        this.showBabyAgeQuestion();
        this.showDueDateQuestion();
        this.showTwinsQuestion();
        break;
      case "I'm just browsing or have advice.":
        answers[3] = '0-3 mo';
        this.kid.set('age_range', '0-3 mo');
        this.hideBabyAgeQuestion();
        this.hideDueDateQuestion();
        this.hideTwinsQuestion();
        break;
    }

    this.model.set('answers', answers);

    return false;
  },

  showBabyAgeQuestion: function() {
    $('#q02-04', this.$el).show();
  },

  hideBabyAgeQuestion: function() {
    $('#q02-04', this.$el).hide();
  },

  showDueDateQuestion: function() {
    $('#q02-03', this.$el).show(function() {
      $("label", $(this)).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

      if($(window).width() > 480) {
        $("#field-bdate").attr('type', 'text');
        $("#field-bdate").datepicker();
      } else {
        $("#field-bdate").attr('type', 'date');
      }
    });
  },

  hideDueDateQuestion: function() {
    $('#q02-03', this.$el).hide();
  },

  showTwinsQuestion: function() {
    $('#q02-02', this.$el).show();
  },

  hideTwinsQuestion: function() {
    $('#q02-02', this.$el).hide();
  },

  showBabyAges: function(event) {
    event.preventDefault();

    var answerList = $(event.target, this.$el).parents('a').siblings('ol');
    answerList.css('width', '5.5em');
    answerList.css('max-height', '5.1em');
    answerList.css('overflow', 'auto');
    answerList.show();
    answerList.scrollTop(1).scrollTop(0);

    return false;
  },

  selectBabyAge: function(event) {
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
    answers[3] = answerText;
    this.model.set('answers', answers);

    return false;
  },

  toggleMultiples: function(event) {
    var answers = this.model.get('answers');
    var checked = $(event.currentTarget).is(":checked");
    answers[1] = checked;
    this.kid.set('multiples', checked);
    this.model.set('answers', answers);
  },

  saveKid: function(event) {
    event.preventDefault();

    Mamajamas.Context.Progress.show();
    var _view = this;
    var answers = this.model.get('answers');
    var dueDate = $("#field-bdate").val();
    answers[2] = dueDate;
    this.kid.set('due_date', dueDate);
    this.model.set('answers', answers);
    Mamajamas.Context.Kids.create({
      kid: {
        age_range_name: this.kid.get('age_range'),
        due_date: dueDate,
        multiples: this.kid.get('multiples')
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
        _view.save(event);
      }
    });

    return false;
  },

  justBrowsing: function() {
    var status = this.model.get("answers")[0];
    return (status === "am just browsing or have advice.");
  },

});
