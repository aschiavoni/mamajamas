Mamajamas.Views.GiftNew = Backbone.View.extend({

  _tabs: null,

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

  _showTab: function(idx) {
    this._tabs.showAccessibleTab(idx);
  }

});
