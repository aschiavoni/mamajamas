Mamajamas.Views.Progress = Backbone.View.extend({

  initialize: function() {
  },

  render: function() {
    return this;
  },

  show: function() {
    $('#loader-wrap').show();
  },

  hide: function() {
    _.delay(function() {
      $('#loader-wrap').hide();
    }, 200);
  },

});
