Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.editing = false;
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:age", this.saveAndRender, this);
    this.model.on("change:priority", this.saveAndRender, this);
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "change .prod-owned": "updateOwned",
    "click .ss-write": "edit",
    "click .ss-delete": "delete",
    "click .prod-note": "toggleNote",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("td.rating", this.$el).append(ratingView.render().$el);

    var ageRangeView = new Mamajamas.Views.ListItemAgeRange({
      model: this.model
    });
    this.$el.append(ageRangeView.render().$el);

    var priorityView = new Mamajamas.Views.ListItemPriority({
      model: this.model
    });
    this.$el.append(priorityView.render().$el);

    return this;
  },

  edit: function() {
    this.editing = true;

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
    if (confirm("Are you sure you want to delete this item?")) {
      this.model.destroy({
        wait: true,
        success: function() {
          Mamajamas.Context.ListItems.remove(this.model);
        },
        error: function(model, response, options) {
          Mamajamas.Context.Notifications.error("We could not remove this list item at this time. Please try again later.");
        }
      });
    }
    return false;
  },

  updateRating: function() {
    this.model.save();
  },

  saveAndRender: function() {
    if (this.editing)
      return;
    this.model.save();
    this.render();
  },

  updateOwned: function(event) {
    var $owned = $(event.target);
    this.model.set("owned", $owned.is(":checked"));
    this.model.save();
  },

  toggleNote: function(event) {
    var $target = $(event.target);
    if ($target.hasClass("closed")) {
      $target.removeClass("closed").addClass("open");
    } else {
      $target.removeClass("open").addClass("closed");
    }
  }

});
