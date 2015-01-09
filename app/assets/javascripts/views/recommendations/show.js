Mamajamas.Views.Recommendation = Backbone.View.extend({

  className: 'prod prod-filled clearfix',

  template: HandlebarsTemplates["recommendations/show"],

  initialize: function() {
    this.$el.attr('id', this.model.id);
  },

  events: {
    'click a.bt-add': 'addItem'
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  addItem: function(event) {
    event.preventDefault();
    var _view = this;
    var $prod = $(event.currentTarget).parents('.prod');
    var recId = parseInt($prod.attr('id'));

    $.post('/api/recommendations/' + recId, function(data) {
      var rec = Mamajamas.Context.Recommendations.get(recId);
      Mamajamas.Context.Recommendations.remove(rec);

      _view.$el.slideUp(function() {
        this.remove();
      });
    }).fail(function() {
      alert("We apologize. We could not add that recommendation");
    });

    return false;
  }

});
