window.Mamajamas.Views.LoginModal = Backbone.View.extend({

  signInPath: "/list",

  initialize: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });

    this.initializeCollapsible();

    this.model.on('server:authenticating', this.showProgress, this);
    this.model.on('server:authenticated', this.onAuthenticated, this);
    this.model.on('server:unauthorized', this.onUnauthorized, this);
  },

  events: {
    "click #bt-cancel": "hide",
    "submit #login-form": "submit",
    "submit #private-list-login-form": "submitPrivate",
    "click .modal-overlay": "close",
    "click .bt-close": "close",
    "click #bt-fb-connect": "facebookLogin",
  },

  render: function(event) {
    return this;
  },

  initializeCollapsible: function() {
    $("#login-form .collapsible, #private-list-login-form .collapsible",
      this.$el).collapsible({
      cssClose: "ss-directright",
      cssOpen: "ss-dropdown",
      speed: 200,
      // these names are confusing
      // animateClose is actually called when the collapsible expands
      animateClose: this.openCollapsible,
      animateOpen: this.closeCollapsible
    });
  },

  openCollapsible: function(elem, opts) {
    elem.next().slideDown(opts.speed, function() {
      $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      // TODO: remove this if we get rid of inFieldLabels
      // it is necessary to refresh the placeholders
      // when the modal is re-opened
      $("input", this.$el).blur();
      $("#user_login", this.$el).focus();
    });
  },

  closeCollapsible: function(elem, opts) {
    elem.next().slideUp(opts.speed, function() {
    });
  },

  showProgress: function() {
    this.$el.progressIndicator('show');
  },

  hideProgress: function() {
    this.$el.progressIndicator('hide');
  },

  clearError: function() {
    $(".collapsible-content p.instruction.error", this.$el).remove();
  },

  show: function() {
    var _view = this;
    this.$el.show(0, function() {
      $("#user_login", _view.$el).focus();
    });
  },

  hide: function() {
    this.$el.progressIndicator('hide').hide();
    this.clearError();
  },

  close: function(event) {
    event.preventDefault();
    this.hide();
    return false;
  },

  onAuthenticated: function() {
    var redirectPath = this.afterSignInPath();

    if (redirectPath != "/registry" && this.model.get("sign_in_count") <= 1) {
      window.location = "/friends";
    }
    else {
      window.location = redirectPath;
    }
  },

  onUnauthorized: function() {
    this.hide();
    Mamajamas.Context.Notifications.error("You cannot be logged in at this time.");
  },

  submitPrivate: function(event) {
    this.setAfterSigninPath();
    submit(event);
  },

  facebookLogin: function(event) {
    this.setAfterSigninPath();
    return true;
  },

  setAfterSigninPath: function() {
    this.signInPath = window.location.pathname;
  },

  afterSignInPath: function() {
    var grp = $.cookies.get("after_sign_in_path");
    if (grp != null) {
      this.signInPath = grp;
    }
    return this.signInPath;
  },

  submit: function(event) {
    event.preventDefault();
    var _session = this.model;
    var _view = this;
    var $form = $(".login-form", this.$el);
    $("button[type=submit]", $form).attr("disabled", "disabled");

    _session.trigger('server:authenticating');
    // post to the server
    $.post($form.attr("action"), $form.serialize(), function(data) {
      _view.hideProgress();
      _view.clearError();
      $("button[type=submit]", $form).attr("disabled", null);
      if (data.errors) {
        for (var errorField in data.errors) {
          if (errorField == "base") {
            var errMsg = data.errors[errorField][0];
            var $errorTag = $("<p>").addClass("instruction").addClass("error").html(errMsg);
            $('.collapsible-content', _view.$el).prepend($errorTag);
          } else {
            var $field = $("#user_" + errorField, _view.$el);
            var $errorTag = $("<strong>").addClass("status-msg").addClass("error");
            $errorTag.html(data.errors[errorField][0]);
            $field.after($errorTag);
          }
        }
      } else {
        _session.trigger('server:authenticated');
      }
    });
    return false;
  },

});
