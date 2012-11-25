Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.model.on("change:rating", this.updateRating);
    this.$el.attr("id", "list-item-" + this.model.get("id"));
  },

  events: {
    "change .prod-owned": "updateOwned",
    "click .ss-write": "edit",
    "click .ss-delete": "delete"
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);
    return this;
  },

  edit: function() {
    var editView = new Mamajamas.Views.ListItemEdit({
      model: this.model,
      parent: this
    });

    this.$el.after(editView.render().$el);
    this.$el.hide();
    editView.setup();

    return false;
  },

  delete: function() {
    this.model.destroy({
      wait: true,
      success: function() {
        Mamajamas.Context.ListItems.remove(this.model);
      },
      error: function(model, response, options) {
        Mamajamas.Context.Notifications.error("We could not remove this list item at this time. Please try again later.");
      }
    })
    return false;
  },

  updateRating: function() {
    // this is the model
    this.save();
  },

  updateOwned: function(event) {
    var $owned = $(event.target);
    this.model.set("owned", $owned.is(":checked"));
    this.model.save();
  }
});
