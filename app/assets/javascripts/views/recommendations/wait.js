Mamajamas.Views.RecommendationsWait = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates["quiz/wait"],

  delay: 1000,

  editor: null,

  initialize: function() {
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model));

    if (!this.editor.model.list.id || !this.hasFetchedRecommendations)
      this.check(this);

    return this;
  },

  doNothing: function(event) {
    return false;
  },

  check: function(_view) {
    var _editor = _view.editor;
    $.ajax("/list/check", {
      dataType: "json",
      success: function(data) {
        if (data.complete) {
          $('.listsort a').prop('disabled', false);
          $('.listsort a').off('click', _view.doNothing);
          if (_editor) {
            _editor.model.list.set(data);
            if (Mamajamas.Context.Recommendations.length == 0)
              Mamajamas.Context.Recommendations.fetch();
            else
              _editor.renderRecommendations();
          }
        } else {
          _.delay(_view.check, _view.delay, _view);
          _view.delay = _view.delay * 1.1;
        }
      }
    });
  }

});
