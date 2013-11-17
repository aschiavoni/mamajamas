Mamajamas.Views.PublicListPrivate = Backbone.View.extend({

  initialize: function() {
    $("#login-modal").remove();
    $('#private-modal').modal({
      position: ['15%',null],
      closeClass: 'modalClose',
      closeHTML:''
    });
  },

});
