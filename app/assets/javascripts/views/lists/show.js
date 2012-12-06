Mamajamas.Views.ListShow = Backbone.View.extend({

  template: HandlebarsTemplates['lists/show'],

  render: function() {
    this.$el.html(this.template);
    return this;
  }

});
