Mamajamas.Views.GiftNew = Backbone.View.extend({

  _tabs: null,

  _visitedProductSite: false,

  initialize: function() {
    var _view = this;
    _view._tabs = $(".tabs").accessibleTabs({
      tabhead:'h3',
      fx:'fadeIn',
      tabsListClass:'menu',
      autoAnchor:true,
      saveState:true
    });

    _view.inFieldLabels();

    $('#step1-continue', _view.$el).click(_view.step1Continue.bind(_view));
    $('#step2-continue', _view.$el).click(_view.step2Continue.bind(_view));
  },

  events: {
  },

  inFieldLabels: function() {
    $('label').inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  step1Continue: function(event) {
    event.preventDefault();
    this._showTab(1);
    return false;
  },

  step2Continue: function(event) {
    if (!this._visitedProductSite) {

      _.delay(function() {
        var $button = $(event.currentTarget);
        $button.html("Continue");
        $button.blur();
      }, 1000, event);

      this._visitedProductSite = true;
      return true;
    }

    this._showTab(2);
    return false;
  },

  _showTab: function(idx) {
    this._tabs.showAccessibleTab(idx);
  }

});
