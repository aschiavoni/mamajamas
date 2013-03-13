Mamajamas.Views.QuizQuestion = Backbone.View.extend({

  template: HandlebarsTemplates['quiz/intro'],

  className: 'quiz-box large',

  initialize: function() {
    this.$el.attr("id", "quiz01");
  },

  events: {
    'click #bt-start': 'start'
  },

  render: function() {
    this.$el.html(this.template());
    return this;
  },

  start: function(event) {
    event.preventDefault();
    return false;
  },

})
