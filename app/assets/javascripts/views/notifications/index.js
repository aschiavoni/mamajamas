Mamajamas.Views.NotificationsIndex = Backbone.View.extend({

  initialize: function() {
    this.collection.on("add", this.appendItem, this);
    this.collection.on("reset", this.clear, this);
  },

  render: function() {
    return this;
  },

  appendItem: function(item) {
    var showView = new Mamajamas.Views.NotificationShow({
      model: item
    });
    $("#notifications").append(showView.render().$el);
  },

  clear: function() {
    $("#notifications").html(null);
  }
})
