Mamajamas.Views.RecommendationsEditor = Backbone.View.extend({

  className: 'modal-win quiz-results',

  template: HandlebarsTemplates["quiz/recommendations"],

  filter: null,

  disabledControls: false,

  hasFetchedRecommendations: false,

  emptyView: null,

  rendered: false,

  standalone: false,

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

    if (!this.standalone) {
      $('body').on('click', '#bt-rec-next', $.proxy(this.next, this));
      $('body').on('click', '#bt-rec-prev', $.proxy(this.previous, this));
    }

    this.hasFetchedRecommendations = Mamajamas.Context.Recommendations.length > 0;
  },

  events: {
    "click .choicedrop > a": "toggleCategories",
    "click .choicedrop ul li a": "selectCategory",
    "click .bt-add-all": "addAllRecommendations",
    "click .bt-rec-close": "closeModal"
  },

  render: function() {
    if (this.standalone) {
      this.$el.css("display", "none");
      this.$el.attr("id", "recommendations-editor");
    }

    this.$el.html(this.template({
      list: this.model.list.toJSON(),
      recommendations: this.model.recommendations.toJSON,
      categories: this.model.categories,
      standalone: this.standalone
    }));

    if (this.model.list.id === null || this.model.recommendations.length === 0) {
      this.showWaitView();
    }

    $('#simplemodal-container').css('height', 'auto');
    this.rendered = true;
    this.renderRecommendations();
    return this;
  },

  showWaitView: function() {
    this.disabledControls = true;
    var waitModel = {};
    waitModel['message'] = 'Please wait while we get your recommendations...';

    var waitView = new Mamajamas.Views.RecommendationsWait({ model: waitModel });
    waitView.editor = this;
    this.disableButtons();

    var $buttons = $('a.button', this.$el);
    $buttons.addClass('disabled');

    $('.prodlist', this.$el).html(waitView.render().$el);
  },

  enableButtons: function() {
    var $buttons = $('a.button', this.$el);
    $buttons.removeClass('disabled');
  },

  disableButtons: function() {
    var $buttons = $('a.button', this.$el);
    $buttons.addClass('disabled');
  },

  showAsModal: function(categoryId) {
    var _view = this;
    if (categoryId)
      this.setFilter(categoryId);

    $("#" + this.$el.attr("id")).modal({
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
			maxHeight:'610',
      position:['7%', null],
      // focus: false,
      // escClose: false,
      // overlayClose: false,
      onClose: _view.closeModal
    });
  },

  closeModal: function(event) {
    $.modal.close();
    $('#recommendations-editor').remove();
    return false;
  },

  setStandalone: function(isStandalone) {
    this.standalone = isStandalone == true;
    this.model.standalone = this.standalone;
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
    this.enableButtons();
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
      if (_view.standalone) {
        _.delay(function() {
          window.location.reload(true);
        }, 1000);
      }
    }).fail(function() {
      alert("We apologize. We could not add recommendations right now.");
    });

    return false;
  },

  selectCategory: function(event) {
    if (this.disabledControls) {
      return false;
    }

    var $target = $(event.currentTarget);
    var $list = $target.parents("ul");
    var value = $target.html();
    var categoryId = $target.attr('href').replace('#', '');

    if (categoryId === 'all')
      categoryId = null;

    $list.hide();
    this.setFilter(categoryId);

    return false;
  },

  setFilter: function(categoryId) {
    var value;
    var cat = _.find(Mamajamas.Context.Categories, function(category) {
      return category.id == categoryId;
    });

    if (cat)
      value = cat.name;
    else
      value = 'All';

    this.filter = categoryId;
    $('.choicedrop > a', this.$el).html(
      value + " <span class=\"ss-dropdown\"></span>"
    );
    this.renderRecommendations();
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
