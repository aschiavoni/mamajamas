window.Mamajamas.Views.LoginModal = Backbone.View.extend({
  initialize: function() {
    _loginModal = this;
    this.model.on('serverAuthenticating', this.showProgress)
    this.model.on('serverAuthenticated', this.hide)
  },
  events: {
    "click #bt-cancel": "hide"
  },
  render: function(event) {
    return this;
  },
  showProgress: function() {
    _loginModal.$el.progressIndicator('show');
  },
  hideProgress: function() {
    _loginModal.$el.progressIndicator('hide');
  },
  hide: function() {
    _loginModal.$el.progressIndicator('hide').hide();
  }
});

