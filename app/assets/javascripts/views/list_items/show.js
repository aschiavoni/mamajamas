Mamajamas.Views.ListItemShow = Backbone.View.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/show'],

  className: "prod prod-filled",

  initialize: function() {
    this.model.on("change:rating", this.updateRating, this);
    this.model.on("change:when_to_buy", this.updateWhenToBuy, this);
    this.$el.attr("id", "list-item-" + this.model.get("id"));
  },

  events: {
    "change .prod-owned": "updateOwned",
    "click .ss-write": "edit",
    "click .ss-delete": "delete",
    "click .prod-drop .prod-drop-arrow": "toggleWhenToBuyList",
    "click .prod-drop ul li a": "selectWhenToBuy"
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
    this.model.save();
  },

  updateWhenToBuy: function() {
    this.model.save();
    this.render();
  },

  updateOwned: function(event) {
    var $owned = $(event.target);
    this.model.set("owned", $owned.is(":checked"));
    this.model.save();
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

  selectWhenToBuy: function(event) {
    var $target = $(event.target);
    var $whenList = $target.parents("ul");
    var whenToBuy = $target.html();

    this.model.set("when_to_buy", whenToBuy);
    $whenList.addClass("visuallyhidden");
  }

});
