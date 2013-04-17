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
    this.pruneList();
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-build': 'save',
    'click .skip': 'skip',
    'click #country-select': 'showCountries',
    'click .country-name': 'selectCountry',
  },

  rendered: function() {
    setTimeout(function() {
      $('label', this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      if ($('#zip_code', this.$el).val() == '')
        $('#zip_code', this.$el).focus();
    }, 0);
  },

  save: function(event) {
    event.preventDefault();
    this.trigger('quiz:question:saving');

    var _view = this;
    $.ajax({
      url: '/api/update_zip_code',
      type: 'PUT',
      data: {
        zip_code: $('#zip_code', this.$el).val(),
        country: $('#country', this.$el).val(),
      },
      success: function(data, status, xhr) {
        _view.clearErrors();
        _view.trigger('quiz:question:saved');
      },
      error: function(response, status, error) {
        var data = $.parseJSON(response.responseText);
        if (data.errors) {
          for (var err in data.errors) {
            _view.displayError(data.errors[err]);
          }
        } else {
          Mamajamas.Context.Notifications.error('Please try again later.');
        }
      }
    });

    return false;
  },

  displayError: function(errorMessage) {
    this.clearErrors();
    var $errSpan = $("<span/>");
    $errSpan.html(errorMessage);

    var $errDiv = $("<div/>");
    $errDiv.css('font-size', '24px');
    $errDiv.css('margin-top', '-28px');
    $errDiv.addClass('q08-error');
    $errDiv.addClass('error');
    $errDiv.html($errSpan.html());

    $('#q08-02').after($errDiv);
  },

  clearErrors: function() {
    $('.q08-error').remove();
  },

  pruneList: function() {
    $.ajax({
      url: '/api/prune_list',
      type: 'POST'
    });
  },

  showCountries: function(event) {
    event.preventDefault();

    var answerList = $(event.target, this.$el).parents('a').siblings('ol');
    answerList.css('width', '10em');
    answerList.css('max-height', '6.5em');
    answerList.css('overflow', 'auto');
    answerList.show();

    return false;
  },

  selectCountry: function(event) {
    event.preventDefault();

    var answer = $(event.target, this.$el);
    var answerList = answer.parents('ol');
    answerList.css('width', null);
    answerList.css('max-height', null);
    answerList.css('overflow', null);
    answerList.hide();

    var answerText = answer.data('country-code');
    $('#country-select-desc', this.$el).html(answer.html());
    $('#country', this.$el).val(answerText);

    return false;
  },

})

