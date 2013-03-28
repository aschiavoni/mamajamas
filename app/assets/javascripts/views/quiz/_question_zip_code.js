Mamajamas.Views.QuizZipCode = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/zip_code'],

  quizId: 'quiz08',

  large: true,

  initialize: function() {
    this.$el.attr('id', this.quizId);
    if (this.large)
      this.$el.addClass("large");
    this.on('quiz:question:rendered', this.rendered, this);
    this.on('quiz:question:saved', this.next, this);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-build': 'save',
    'click .skip': 'skip',
  },

  rendered: function() {
    setTimeout(function() {
      $('label', this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $('#zip_code', this.$el).focus();
    }, 200);
  },

  save: function(event) {
    event.preventDefault();

    var _view = this;
    $.ajax({
      url: '/api/update_zip_code',
      type: 'PUT',
      data: {
        zip_code: $('#zip_code', this.$el).val()
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

})

