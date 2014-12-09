window.Mamajamas.Views.EmailShareModal = Backbone.View.extend({

  initialize: function() {
  },

  events: {
  },

  render: function() {
    $(".simplemodal-container .create-email-form label", this.$el).inFieldLabels({
      fadeDuration:200,
      fadeOpacity:0.55
    });
    $('#bt-cancel', this.$el).click(this.close);
    $('form', this.$el).submit(this.share.bind(this));
    return this;
  },

  show: function() {
    this.$el.modal({
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
      overlayClose: true
    });
    this.render();
  },

  close: function() {
    $.modal.close();
  },

  clearErrors: function() {
    $('.status-msg.error', this.$el).remove();
  },

  share: function(event) {
    var _view = this;
    event.preventDefault();

    var $form = $(event.currentTarget);
    this.clearErrors();
    $.post($form.attr('action'), $form.serialize(), function(data) {
      _view.close();
      Mamajamas.Context.Notifications.success("Thanks for sharing!");
    }).fail(function(response) {
      var data = JSON.parse(response.responseText);
      if (data.errors) {
        for (var errorField in data.errors) {
          var $field = $("#invite_" + errorField, _view.$el);
          var $errorTag = $("<strong>").addClass("status-msg").addClass("error");
          $errorTag.html(data.errors[errorField][0]);
          $field.after($errorTag);
        }
      }
    });

    return false;
  }

});
