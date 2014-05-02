Mamajamas.Views.QuizCustomList = Mamajamas.Views.QuizQuestion.extend({

  template: HandlebarsTemplates['quiz/custom_list'],

  questionName: 'Custom List',

  quizId: 'quiz09',

  large: false,

  initialize: function() {
    this.$el.attr('id', this.quizId);
    this.on('quiz:question:saved', this.next, this);
    this.on('quiz:question:rendered', this.rendered, this);
  },

  events: {
    'click #bt-prev': 'previous',
    'click #bt-next': 'save',
    'click .skip': 'save',
    'click #bt-build': 'save',
    'change input[name=prodrecc-radio]': 'customListToggle',
    'click .gallery-a': 'showPreviewA',
    'click .gallery-b': 'showPreviewB',
  },

  rendered: function() {
    var _view = this;
    if (this.model.get("answers")[0] === "true") {
      _.defer(function() {
        $('#custom-list').prop('checked', true);
      });
    }
  },

  customListToggle: function(event) {
    var $selected = $(event.currentTarget);
    var selectedId = $selected.attr("id");

    var answer = "false";
    if (selectedId == "custom-list") {
      answer = "true";
      $('li:first-child .thumb').css("z-index", "");
      $('li:last-child .thumb').css("z-index", 40051);
    } else {
      $('li:first-child .thumb').css("z-index", 40051);
      $('li:last-child .thumb').css("z-index", "");
    }
    this.model.set("answers", [ answer ]);

    return true;
  },

  showPreviewA: function(event) {
    if (event)
      event.preventDefault();
    this.showPreview('#gallery-modal-a');
    return false;
  },

  showPreviewB: function(event) {
    if (event)
      event.preventDefault();
    this.showPreview('#gallery-modal-b');
    return false;
  },

  returnToQuiz: function(event) {
    event.preventDefault();
    $(".question-content").show();
    $("a.simplemodal-close").show();
    var _view = event.data;
    _view.hidePreview("#gallery-modal-a");
    _view.hidePreview("#gallery-modal-b");
    return false;
  },

  showPreview: function(selector) {
    var $preview = $(selector);
    $(".question-content").hide();
    $(".quiz-return", $preview).on("click", this, this.returnToQuiz);
    $(".toggle-preview", $preview).on("click", this, this.togglePreview);
    $("a.simplemodal-close").hide();
    $preview.show();
  },

  hidePreview: function(selector) {
    var $preview = $(selector);
    $preview.hide();
    $(".quiz-return", $preview).off("click", this, this.returnToQuiz);
    $(".toggle-preview", $preview).off("click", this, this.togglePreview);
  },

  togglePreview: function(event) {
    event.preventDefault();
    var $currentPreview = $(event.currentTarget);
    var targetPreviewSelector = $currentPreview.data("toggle-preview-target");
    var currentPreviewSelector =
      "#" + $currentPreview.parents(".quiz-modal").attr("id");
    var _view = event.data;
    _view.showPreview(targetPreviewSelector);
    _view.hidePreview(currentPreviewSelector);
    return false;
  },

});
