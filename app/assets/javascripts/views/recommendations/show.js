Mamajamas.Views.Recommendation = Backbone.View.extend({

  className: 'prod prod-filled clearfix',

  template: HandlebarsTemplates["recommendations/show"],

  initialize: function() {
    this.$el.attr('id', this.model.id);
  },

  events: {
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});
