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

    $('.collapsible', _view.$el).collapsible({
      cssClose: 'coll-closed',
    	cssOpen: 'coll-open',
		  speed:200
    });

	  $('#close-coll').click(function(event) {
		  event.preventDefault();
		  $('.collapsible', _view.$el).collapsible('close');
      return false;
	  });
  },

  events: {
  },

  inFieldLabels: function() {
    $('label').inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  step1Continue: function(event) {
    event.preventDefault();
    var listItemId = Mamajamas.Context.Gift.list_item_id;
    var data = {
      "gift": {
        "list_item_id": listItemId,
        "full_name": $('#gift_full_name').val() || Mamajamas.Context.Gift.full_name,
        "email": $('#gift_email').val() || Mamajamas.Context.Gift.email,
        "purchased": true,
        "quantity": 1
      },
      "list_item_id": listItemId
    };
    $.post('/gifts/' + listItemId + '.json', data, function(response) {
      $('#gift_id').val(response.id);
    });
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
    var prevIdx = idx - 1;
    var sel = '.tabs > ul li';
    var prevTab = $($(sel, this.$el)[prevIdx]);
    if (prevTab.length > 0)
      prevTab.addClass('complete');
  }

});
