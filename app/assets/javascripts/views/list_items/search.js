Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  initialize: function() {
  },

  events: {
    'click .bt-close': 'close',
    'keyup #field-search': 'search'
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

  search: _.throttle(function() {
    var _view = this;
    this.$el.progressIndicator('show');
    // console.log('search: ' + new Date());
    setTimeout(function() {
      _view.$el.progressIndicator('hide');
    }, 2000);
  }, 1000),

});
