Mamajamas.Views.HomeIndex = Backbone.View.extend({

  initialize: function() {
    var _view = this;

    $("#learn-more").click(function (e) {
      e.preventDefault();
      _view.scrollToElement("#secondary");
    });

    $("#create-registry").click(function(e) {
      e.preventDefault();
      Mamajamas.Context.AppAuth.signup();
      return false;
    });
  },

  scrollToElement: function(selector, time, verticalOffset) {
    time = typeof(time) != 'undefined' ? time : 500;
    verticalOffset = typeof(verticalOffset) != 'undefined' ? verticalOffset : 0;
    element = $(selector);
    offset = element.offset();
    offsetTop = offset.top + verticalOffset;
    $('html, body').animate({
      scrollTop: offsetTop
    }, time);
  },

});
