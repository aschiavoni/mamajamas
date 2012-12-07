Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:when_to_buy", this.saveAndRender, this);
    this.model.on("change:priority", this.saveAndRender, this);
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "change .prod-owned": "updateOwned",
    "click .ss-write": "edit",
    "click .ss-delete": "delete",
    "click td.when .prod-drop .prod-drop-arrow": "toggleWhenToBuyList",
    "click td.when .prod-drop ul li a": "selectWhenToBuy",
    "click td.priority .priority-display": "togglePriorityList",
    "click td.priority .prod-drop ul li a": "selectPriority",
    "click .prod-note": "toggleNote"
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
  },

  toggleWhenToBuyList: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.parents(".prod-drop");
    var $whenList = $prodDrop.find("ul");

    if ($whenList.hasClass("visuallyhidden")) {
      $whenList.removeClass("visuallyhidden");
    } else {
      $whenList.addClass("visuallyhidden");
    }

    return false;
  },

  togglePriorityList: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.siblings(".prod-drop");

    if ($prodDrop.hasClass("hidden")) {
      $prodDrop.removeClass("hidden");
    } else {
      $prodDrop.addClass("hidden");
    }

    return false;
  },

  selectWhenToBuy: function(event) {
    var $target = $(event.target);
    var $whenList = $target.parents("ul");
    var whenToBuy = $target.html();

    this.model.set("when_to_buy", whenToBuy);
    $whenList.addClass("visuallyhidden");

    return false;
  },

  selectPriority: function(event) {
    var $target = $(event.target);
    var $prodDrop = $target.parents(".prod-drop");
    var priorityClass = $target.parents("li").attr("class");

    var newPriority = 3;
    switch(priorityClass) {
      case "priority-low":
        newPriority = 3;
        break;
      case "priority-med":
        newPriority = 2;
        break;
      case "priority-high":
        newPriority = 1;
        break;
    }

    this.model.set("priority", newPriority);
    $prodDrop.addClass("hidden");

    return false;
  }

});
