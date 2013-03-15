Mamajamas.Routers.Quiz = Backbone.Router.extend({

  initialize: function() {
    Mamajamas.Context.Kids = new Mamajamas.Collections.Kids();
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
