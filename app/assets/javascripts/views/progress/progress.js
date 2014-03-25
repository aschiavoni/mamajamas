// this should be called QuizProgress
Mamajamas.Views.Progress = Backbone.View.extend({

  template: HandlebarsTemplates['progress/progress'],

  initialize: function() {
  },

  render: function() {
    return this;
  },

  show: function() {
    $("#quiz-modal .quiz-box-s").append(this.template());
  },

  hide: function() {
    $('#loader-wrap').remove();
  },

});
