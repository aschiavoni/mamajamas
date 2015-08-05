Mamajamas.Views.ListWait = Mamajamas.Views.Base.extend({
  delay: 1000,

  initialize: function() {
    this.check(this);
    $('#categories a, #bt-share, #bt-view').click(function(event) {
      return false;
    });
  },

  events: {
  },

  render: function() {
    return this;
  },

  check: function(_view) {
    $.ajax("/list/check", {
      dataType: "json",
      success: function(data) {
        if (data.complete) {
          location.reload();
        } else {
          _.delay(_view.check, _view.delay, _view);
          _view.delay = _view.delay * 1.1;
        }
      }
    });
  },

});
