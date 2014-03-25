Mamajamas.Views.QuizCustomList = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/custom_list'],

  questionName: 'Custom List',

  quizId: 'quiz09',

  large: false,

  initialize: function() {
    this.$el.attr('id', this.quizId);
    this.on('quiz:question:saved', this.next, this);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click .skip': 'save',
    'click #bt-build': 'save',
    'change input[name=prodrecc-radio]': 'customListToggle'
  },

  customListToggle: function(event) {
    var $selected = $(event.currentTarget);
    var selectedId = $selected.attr("id");

    var answer = "false";
    if (selectedId == "custom-list") {
      answer = "true";
    }
    this.model.set("answers", [ answer ]);

    return true;
  },

});
