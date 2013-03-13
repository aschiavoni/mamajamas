Mamajamas.Routers.Quiz = Backbone.Router.extend({

  initialize: function() {
  },

  routes: {
    '': 'index'
  },

  index: function() {
    var quizView = new Mamajamas.Views.QuizShow({
      el: '#quiz'
    });
  }

})
