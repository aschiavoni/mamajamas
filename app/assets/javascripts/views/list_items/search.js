Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  lastSearch: null,

  searchResults: null,

  suggestions: null,

  initialize: function() {
    this.$el.attr("id", "search-modal");
    this.searchResults = new Mamajamas.Collections.SearchResults();
    this.searchResults.on('reset', this.showResults, this);

    var productTypeId = this.model.get('product_type_id');
    if (productTypeId != null) {
      this.suggestions = new Mamajamas.Collections.ProductTypeSuggestions(null, {
        productTypeId: productTypeId
      });
      this.suggestions.on('reset', this.showSuggestions, this);
    }
  },

  events: {
    'keyup #field-search': 'searchMaybe',
    'submit #frm-prod-search': 'submit',
  },

  render: function() {
    var _view = this;

    this.$el.html(this.template(this.model.toJSON()));

    var addYourOwnView = new Mamajamas.Views.ListItemAddYourOwn({
      model: this.model
    });
    addYourOwnView.on('search:product:added', _view.addManualItem, _view);
    $('#prod-search-results', this.$el).after(addYourOwnView.render().$el);

    if (this.suggestions != null) {
      this.loadSuggestions();
    }
    else {
      _.defer(function() {
        _view.showSuggestions([]);
      });
    }
    return this;
  },

  inFieldLabels: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  show: function() {
    var _view = this;
    this.$el.modal({
      position: ["15%",null],
      zIndex: 5000,
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
      overlayClose: true,
      onShow: function(dialog) {
        _view.inFieldLabels();
        $("#field-search", _view.$el).focus();
      },
      onClose: function(dialog) {
        this.close(); // this is the modal
        _view.$el.remove();
        $("#search-modal").remove(); // make SURE it is removed
      }
    });
  },

  close: function(event) {
    if (event)
      event.preventDefault();
    $.modal.close();
    return false;
  },

  submit: function(event) {
    event.preventDefault();
    this.searchMaybe();
    return false;
  },

  searchMaybe: _.debounce(function(event) {
    var searchField = $(event.target);
    var query = searchField.val().trim();

    // dont't search if it is the same query or too short of a query
    if (query.length > 1 && this.lastSearch != query) {
      this.lastSearch = query;
      this.search(query);
    }

    return true;
  }, 500, false),

  search: function(query) {
    var _view = this;

    this.clearResults();
    $('#prod-search-results', this.$el).progressIndicator('show');
    $('#prod-search-results .no-search-results', this.$el).hide();

    this.searchResults.fetch({
      data: {
        filter: query,
        name: this.model.get('product_type_name')
      }
    });

    return true;
  },

  clearResults: function() {
    $('#prod-search-results ul.search-results li', this.$el).remove();
    if($(window).width() < 480) {
      $('#prod-suggestions-results ul.suggestions li', this.$el).hide();
      $('#prod-suggestions-results', this.$el).hide();
    }
  },

  showSuggestions: function(searchResults) {
    $('#prod-suggestions-results', this.$el).progressIndicator('hide');
    var $resultsContainer = $('#prod-suggestions-results ul.suggestions', this.$el);
    this.addSearchResultsToContainer(searchResults, this, $resultsContainer);
  },

  showResults: function(searchResults) {
    $('#prod-search-results', this.$el).progressIndicator('hide');
    var $resultsContainer = $('#prod-search-results ul.search-results', this.$el);
    this.addSearchResultsToContainer(searchResults, this, $resultsContainer);
  },

  addSearchResultsToContainer: function(searchResults, _view, $resultsContainer) {
    if (searchResults.length > 0) {
      $('li', $resultsContainer).remove(); // clear existing
      searchResults.each(function(result) {
        var resultView = new Mamajamas.Views.ListItemSearchResult({
          model: result
        });
        resultView.on('search:product:selected', _view.addOrUpdateItem, _view);
        $resultsContainer.append(resultView.render().$el);
      });
    } else {
      $('.no-search-results', $resultsContainer).show();
    }
  },

  addOrUpdateItem: function(searchResult) {
    if (this.model.get('placeholder')) {
      this.addItem(searchResult);
    }
    else {
      this.updateItem(searchResult);
    }
  },

  addManualItem: function(searchResult) {
    var attributes = {
      name: searchResult.get('name'),
      link: " ", // need to use a space to allow infieldlabels to work
      vendor: searchResult.get('vendor'),
      vendor_id: searchResult.get('vendor_id'),
      price: searchResult.get('price'),
      product_type_id: this.model.get('product_type_id'),
      product_type: this.model.get('product_type_name'),
      product_type_name: this.model.get('product_type_name'),
      category_id: this.model.get('category_id'),
      priority: this.model.get('priority'),
      age: this.model.get('age'),
      rating: this.model.get('rating'),
      image_url: searchResult.get('image_url'),
      desired_quantity: this.model.get('desired_quantity'),
      owned_quantity: this.model.get('owned_quantity'),
      owned: this.model.get('owned'),
      placeholder: false,
      edit_mode: true
    };
    Mamajamas.Context.ListItems.add(attributes);
    this.close();
  },

  addItem: function(searchResult) {
    var _view = this;
    var attributes = {
      name: searchResult.get('name'),
      link: searchResult.get('url'),
      vendor: searchResult.get('vendor'),
      vendor_id: searchResult.get('vendor_id'),
      price: searchResult.get('price'),
      product_type_id: this.model.get('product_type_id'),
      product_type: this.model.get('product_type_name'),
      product_type_name: this.model.get('product_type_name'),
      category_id: this.model.get('category_id'),
      priority: this.model.get('priority'),
      age: this.model.get('age'),
      rating: this.model.get('rating'),
      image_url: searchResult.get('image_url'),
      desired_quantity: this.model.get('desired_quantity'),
      owned_quantity: this.model.get('owned_quantity'),
      owned: this.model.get('owned'),
      placeholder: false
    };
    Mamajamas.Context.ListItems.create(attributes, {
      wait: true,
      success: function() {
        var currentItemCount = Mamajamas.Context.List.get('item_count');
        Mamajamas.Context.List.set('item_count', currentItemCount + 1);
        Mamajamas.Context.ListItems.clearPlaceholders(_view.model.get('product_type_id'), _view.model.get('product_type_name'));
      },
      error: function(model, response) {
        Mamajamas.Context.Notifications.error("We're sorry but we could not add this product at this time.");
      }
    });
    this.close();
  },

  updateItem: function(searchResult) {
    var attributes = {
      name: searchResult.get('name'),
      link: searchResult.get('url'),
      image_url: searchResult.get('image_url'),
      rating: null,
      owned: false,
      price: searchResult.get('price'),
      vendor: searchResult.get('vendor'),
      vendor_id: searchResult.get('vendor_id')
    };

    this.model.set(attributes);
    this.model.trigger("search:product:update_item");
    this.close();
  },

  loadSuggestions: function() {
    this.suggestions.fetch();
  },

});
