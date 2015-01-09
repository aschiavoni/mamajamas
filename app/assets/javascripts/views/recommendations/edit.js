Mamajamas.Views.RecommendationsEditor = Backbone.View.extend({

  className: 'modal-win quiz-results',

  template: HandlebarsTemplates["quiz/recommendations"],

  filter: null,

  disabledControls: false,

  hasFetchedRecommendations: false,

  emptyView: null,

  rendered: false,

  initialize: function() {
    this.emptyView = new Mamajamas.Views.RecommendationsEmpty();

    this.$el.attr("id", "quiz-modal").css('display', 'block');

    Mamajamas.Context.Recommendations.on('reset',
                                         this.fetchedRecommendations,
                                         this);

    Mamajamas.Context.Recommendations.on('remove',
                                         this.recommendationRemoved,
                                         this);

    this.model = {
      list: Mamajamas.Context.List,
      recommendations: Mamajamas.Context.Recommendations,
      categories: Mamajamas.Context.Categories
    };

    $('body').on('click', '#bt-rec-next', $.proxy(this.next, this));
    $('body').on('click', '#bt-rec-prev', $.proxy(this.previous, this));
  },

  events: {
    "click .choicedrop > a": "toggleCategories",
    "click .choicedrop ul li a": "selectCategory",
    "click .bt-add-all": "addAllRecommendations"
  },

  render: function() {
    this.$el.html(this.template({
      list: this.model.list.toJSON(),
      recommendations: this.model.recommendations.toJSON,
      categories: this.model.categories
    }));

    if (this.model.list.id === null || this.model.recommendations.length === 0) {
      this.disabledControls = true;
      var waitView = new Mamajamas.Views.RecommendationsWait();
      waitView.editor = this;
      $('.prodlist', this.$el).html(waitView.render().$el);
    }

    $('#simplemodal-container').css('height', 'auto');
    this.rendered = true;
    this.renderRecommendations();
    return this;
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

  fetchedRecommendations: function() {
    this.hasFetchedRecommendations = true;
    if (this.rendered)
      this.renderRecommendations();
  },

  renderRecommendations: function() {
    if (this.model.list.id === null || !this.hasFetchedRecommendations) {
      return;
    }

    this.disabledControls = false;
    var $container = $('.prodlist', this.$el);

    $container.html(null);
    var recs = this.filteredRecommendations();
    if (recs.length == 0) {
      this.showEmpty();
    } else {
      _.each(recs, function(item) {
        var $v = new Mamajamas.Views.Recommendation({
          model: item
        }).render().$el;

        $container.append($v);
      }, this);
    }
  },

  filteredRecommendations: function() {
    return this.model.recommendations.filter(function(item) {
      return (!this.filter || item.get("category_id") == this.filter);
    }, this);
  },

  recommendationRemoved: function(o) {
    if (this.filteredRecommendations().length == 0) {
      this.showEmpty();
    }
  },

  showEmpty: function() {
    $('.prodlist', this.$el).html(this.emptyView.render().$el);
  },

  addAllRecommendations:function(event) {
    event.preventDefault();

    var _view = this;
    var recs = this.filteredRecommendations();
    var ids = _.map(recs, function(rec) {
      return rec.id;
    }, this);

    $.post('/api/recommendations/add_all', { 'recs': ids }, function(data) {
      if (_view.filter === null)
        _view.model.recommendations.reset([]);
      else {
        _.each(ids, function(id) {
          var rec = _view.model.recommendations.get(id);
          _view.model.recommendations.remove(rec);
        }, this);
      }
    }).fail(function() {
      alert("We apologize. We could not add recommendations right now.");
    });

    return false;
  },

  selectCategory: function(event) {
    if (this.disabledControls)
      return false;

    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();
    var categoryId = $target.attr('href').replace('#', '');

    if (categoryId === 'all')
      categoryId = null;

    this.filter = categoryId;
    $('.choicedrop > a').html(
      value + " <span class=\"ss-dropdown\"></span>"
    );
    $list.hide();
    this.renderRecommendations();

    return false;
  },

  toggleCategories: function(event) {
    if (this.disabledControls)
      return false;

    var $target = $(event.currentTarget);
    var $choiceDrop = $target.parents(".choicedrop");
    var $list = $choiceDrop.find("ul");

    if ($list.is(":visible")) {
      $list.hide();
    } else {
      $list.show();
    }

    return false;
  }

});
