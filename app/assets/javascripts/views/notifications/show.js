Mamajamas.Views.NotificationShow = Backbone.View.extend({

  tagName: 'p',

  template: HandlebarsTemplates['notifications/show'],

  className: "notification",

  initialize: function() {
    this.$el.addClass("n-" + this.model.get("type"));
  },

  render: function() {
    this.model.set("iconText", this.notificationIconText(this.model.get("type")));
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  notificationIconText: function(type) {
    var text = "";

    switch(type) {
      case "error":
        text = "Caution";
        break;
      case "alert":
        text = "Alert";
        break;
      case "success":
        text = "Check";
        break;
      default:
        text = "Info";
    }

    return text;
  }

})
