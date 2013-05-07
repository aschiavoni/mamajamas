Mamajamas.Views.ListItemSearch = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/search'],

  className: 'modal-wrap',

  initialize: function() {
    console.log('ListItemSearch');
  },

  render: function() {
    this.$el.html(this.template({})).show();
    return this;
  },

});
