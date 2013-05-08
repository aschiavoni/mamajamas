Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  lastSearch: null,

  initialize: function() {
  },

  events: {
    'click .bt-close': 'close',
    'keyup #field-search': 'searchMaybe'
  },

  render: function() {
    this.$el.html(this.template({})).show(function() {
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

  searchMaybe: _.throttle(function(event) {
    var searchField = $(event.target);
    var query = searchField.val().trim();

    // dont't search if it is the same query or no query
    if (query.length >= 1 && this.lastSearch != query) {
      this.lastSearch = query;
      this.search(query);
    }

    return true;
  }, 1000),

  search: function(query) {
    var _view = this;

    this.$el.progressIndicator('show');
    // console.log('search: ' + query + ', at: ' + new Date());
    setTimeout(function() {
      var item = $("<li/>").html(query);
      $('#prod-search-results ul:first').append(item);
      _view.$el.progressIndicator('hide');
    }, 2000);
    return true;
  },

});
