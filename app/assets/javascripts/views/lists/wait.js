Mamajamas.Views.ListWait = Mamajamas.Views.Base.extend({

  initialize: function() {
    this.check(this);
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
          _.delay(_view.check, 1000, _view);
        }
      }
    });
  },

});
