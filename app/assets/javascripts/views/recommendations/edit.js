Mamajamas.Views.RecommendationsEditor = Backbone.View.extend({

  className: 'modal-win quiz-results',

  template: HandlebarsTemplates["quiz/recommendations"],

  filter: null,

  disabledControls: false,

  initialize: function() {
    this.$el.attr("id", "quiz-modal").css('display', 'block');

    Mamajamas.Context.Recommendations.on('reset',
                                         this.renderRecommendations,
                                         this);

    this.model = {
      list: Mamajamas.Context.List,
      recommendations: Mamajamas.Context.Recommendations,
      categories: Mamajamas.Context.Categories
    };
  },

  events: {
    "click .choicedrop > a": "toggleCategories",
    "click .choicedrop ul li a": "selectCategory"
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

    return this;
  },

  renderRecommendations: function() {
    if (this.model.list.id === null || this.model.recommendations.length === 0) {
      return;
    }
    this.disabledControls = false;
    var $container = $('.prodlist', this.$el);

    $container.html(null);
    this.model.recommendations.each(function(item) {
      if (this.filter && item.get("category_id") != this.filter) {
        return;
      }

      var $v = new Mamajamas.Views.Recommendation({
        model: item
      }).render().$el;

      $container.append($v);
    }, this);
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
