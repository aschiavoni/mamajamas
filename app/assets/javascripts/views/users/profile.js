window.Mamajamas.Views.UserProfile = Backbone.View.extend({

  initialize: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  }

});
