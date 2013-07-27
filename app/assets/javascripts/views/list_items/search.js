Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  lastSearch: null,

  searchResults: null,

  suggestions: null,

  initialize: function() {
    this.searchResults = new Mamajamas.Collections.SearchResults();
    this.searchResults.on('reset', this.showResults, this);

    this.suggestions = new Mamajamas.Collections.SearchResults();
    this.suggestions.on('reset', this.showSuggestions, this);
  },

  events: {
    'click #closewindow': 'close',
    'keyup #field-search': 'searchMaybe',
    'submit #frm-prod-search': 'submit',
  },

  render: function() {
    var _view = this
    var productTypeId = this.model.get('product_type_id');
    var ptSuggestion  = Mamajamas.Context.ProductTypeSuggestions.get(productTypeId);
    var _suggestions = [];
    if (ptSuggestion != null)
      _suggestions = ptSuggestion.get('suggestions');

    this.$el.html(this.template(this.model.toJSON())).show(function() {
      _view.suggestions.reset(_suggestions);
      $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#field-search", this.$el).focus();
    });

    var addYourOwnView = new Mamajamas.Views.ListItemAddYourOwn({
      model: this.model
    });
    addYourOwnView.on('search:product:added', _view.addOrUpdateItem, _view);
    $('#prod-search-results', this.$el).after(addYourOwnView.render().$el);

    return this;
  },

  close: function(event) {
    if (event)
      event.preventDefault();
    this.$el.remove();
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
    this.$el.progressIndicator('show');
    $('.no-search-results', this.$el).hide();

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
  },

  showSuggestions: function(searchResults) {
    var $resultsContainer = $('#prod-suggestions-results ul.suggestions', this.$el);
    this.addSearchResultsToContainer(searchResults, this, $resultsContainer);
  },

  showResults: function(searchResults) {
    this.$el.progressIndicator('hide');
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

  addItem: function(searchResult) {
    var attributes = {
      name: searchResult.get('name'),
      link: searchResult.get('url'),
      vendor: searchResult.get('vendor'),
      vendor_id: searchResult.get('vendor_id'),
      product_type_id: this.model.get('product_type_id'),
      product_type: this.model.get('product_type_name'),
      product_type_name: this.model.get('product_type_name'),
      category_id: this.model.get('category_id'),
      priority: this.model.get('priority'),
      age: this.model.get('age'),
      rating: this.model.get('rating'),
      image_url: searchResult.get('image_url'),
      owned: false,
      placeholder: false
    };
    Mamajamas.Context.ListItems.add(attributes);
    this.close();
  },

  updateItem: function(searchResult) {
    var attributes = {
      name: searchResult.get('name'),
      link: searchResult.get('url'),
      image_url: searchResult.get('image_url'),
      rating: null,
      owned: false,
      vendor: searchResult.get('vendor'),
      vendor_id: searchResult.get('vendor_id')
    };

    this.model.set(attributes);
    this.close();
  },

});
