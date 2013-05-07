Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  initialize: function() {
  },

  events: {
    'click .bt-close': 'close',
    'keyup #field-search': 'startSearch',
    'blur #field-search': 'endSearch',
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

  startSearch: function() {
    this.$el.progressIndicator('show');
  },

  endSearch: function() {
    this.$el.progressIndicator('hide');
  },

});
