Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  lastSearch: null,

  searchResults: null,

  initialize: function() {
    this.searchResults = new Mamajamas.Collections.SearchResults();
    this.searchResults.on('reset', this.showResults, this);
  },

  events: {
    'click .bt-close': 'close',
    'keyup #field-search': 'searchMaybe',
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON())).show(function() {
      $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#field-search", this.$el).focus();
    });
    return this;
  },

  close: function() {
    event.preventDefault();
    this.$el.remove();
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

    this.searchResults.fetch({
      data: {
        filter: query
      }
    });

    return true;
  },

  clearResults: function() {
    $('#prod-search-results ul:first li', this.$el).remove();
  },

  showResults: function(searchResults) {
    this.$el.progressIndicator('hide');
    var $resultsContainer = $('#prod-search-results ul:first', this.$el);
    searchResults.each(function(result) {
      var resultView = new Mamajamas.Views.ListItemSearchResult({
        model: result
      });
      $resultsContainer.append(resultView.render().$el);
    });
  },

});
