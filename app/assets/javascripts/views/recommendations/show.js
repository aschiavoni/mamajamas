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

    var rating = this.model.get('rating');
    if (rating && rating > 0) {
      var ratingView = new Mamajamas.Views.ListItemRating({
        model: this.model
      });
      ratingView.readOnly = true;

      var $ratingContainer = $("div.rating", this.$el);
      $ratingContainer.append(ratingView.render().$el);
    }

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

      if (Mamajamas.Context.ListItems) {
        var listItemId = data.id;

        var existing = Mamajamas.Context.ListItems.find(function(item) {
          return item.id == listItemId;
        });

        if (existing)
          Mamajamas.Context.ListItems.remove(existing);

        data['disable_scroll'] = true;
        var added = Mamajamas.Context.ListItems.add(data);
      }

      _view.$el.slideUp(function() {
        this.remove();
      });
    }).fail(function() {
      alert("We apologize. We could not add that recommendation.");
    });

    return false;
  }

});
