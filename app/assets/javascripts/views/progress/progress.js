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
    $('#loader-wrap').hide();
  },

});
