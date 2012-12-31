window.Mamajamas.Views.LoginModal = Backbone.View.extend({
  initialize: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

    this.model.on('server:authenticating', this.showProgress, this);
    this.model.on('server:authenticated', this.onAuthenticated, this);
    this.model.on('server:unauthorized', this.onUnauthorized, this);
  },
  events: {
    "click #bt-cancel": "hide",
    "submit #login-form": "submit"
  },
  render: function(event) {
    return this;
  },
  showProgress: function() {
    this.$el.progressIndicator('show');
  },
  hideProgress: function() {
    this.$el.progressIndicator('hide');
  },
  show: function() {
    var _view = this;
    this.$el.show(0, function() {
      $("#user_login", _view.$el).focus();
    });
  },
  hide: function() {
    this.$el.progressIndicator('hide').hide();
  },
  onAuthenticated: function() {
    if (this.model.get("sign_in_count") <= 1)
      this.hide();
  },
  onUnauthorized: function() {
    this.hide();
    Mamajamas.Context.Notifications.error("You cannot be logged in at this time. Please verify that you have confirmed your email address.");
  },
  submit: function() {
    var _session = this.model;
    var _view = this;
    var $form = $("#login-form", this.$el);
    $("button[type=submit]", $form).attr("disabled", "disabled");

    _session.trigger('server:authenticating');
    // post to the server
    // if the login succeeds, it will return a window.location redirect.
    // if not, it returns the form markup and replaces the existing form.
    $.post($form.attr("action"), $form.serialize(), function(data) {
      if (/^window\.location/.test(data)) {
        _session.trigger('server:authenticated');
      } else {
        $form.replaceWith(data);
        $form = $("#login-form", _view.$el); // get a ref to the new element
        $("label", $form).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
        $("#user_login", $form).focus();
      }
    });
    return false;
  }
});
