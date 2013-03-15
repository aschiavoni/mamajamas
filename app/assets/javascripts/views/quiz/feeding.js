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

    var answer = $(event.target, this.$el).parents('li');
    if (answer.hasClass(this.selectedClass))
      answer.removeClass(this.selectedClass);
    else
      answer.addClass(this.selectedClass);

    this.highlightNext();

    return false;
  },

  highlightNext: function() {
    if ($('ol.q-multi li.' + this.selectedClass, this.$el).length > 0) {
      $('#bt-next', this.$el).addClass('bt-color');
    } else {
      $('#bt-next', this.$el).removeClass('bt-color');
    }
  }

});

