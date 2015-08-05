Mamajamas.Collections.Notifications = Backbone.Collection.extend({
  model: Mamajamas.Models.Notification,

  error: function(message) {
    return this.addNotification(message, "error");
  },

  alert: function(message) {
    return this.addNotification(message, "alert");
  },

  info: function(message) {
    return this.addNotification(message, "info");
  },

  success: function(message) {
    return this.addNotification(message, "success");
  },

  clear: function() {
    this.reset();
  },

  addNotification: function(message, type) {
    return this.add({
      message: message,
      type: type
    });
  }
});
