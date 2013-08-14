Mamajamas.Views.ListItemShow = Mamajamas.Views.Base.extend({

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
    "click .bt-addanother": "addAnother",
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
    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      Mamajamas.Context.ListItems.trigger("list:item:editing");
      this.editing = true;

      var editView = new Mamajamas.Views.ListItemEdit({
        model: this.model,
        parent: this
      });

      this.$el.after(editView.render().$el);
      this.$el.hide();
    }

    return false;
  },

  addAnother: function(event) {
    event.preventDefault();
    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      this.editing = true;

      var editView = new Mamajamas.Views.ListItemEdit({
        model: new Mamajamas.Models.ListItem({
          age: this.model.get('age'),
          age_position: this.model.get('age_position'),
          category: this.model.get('category'),
          category_id: this.model.get('category_id'),
          placeholder: false,
          priority: this.model.get('priority'),
          product_type_id: this.model.get('product_type_id'),
          product_type_name: this.model.get('product_type_name'),
          product_type_plural_name: this.model.get('product_type_plural_name'),
          image_url: "/assets/products/icons/" + this.model.get('product_type_image_name')
        })
      });

      this.$el.parent().prepend(editView.render().$el);
    }

    return false;
  },

  delete: function() {
    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      if (confirm("Are you sure you want to delete this item?")) {
        this.model.destroy({
          wait: true,
          success: function() {
            Mamajamas.Context.ListItems.remove(this.model);
            var currentItemCount = Mamajamas.Context.List.get('item_count');
            Mamajamas.Context.List.set('item_count', currentItemCount - 1);
          },
          error: function(model, response, options) {
            Mamajamas.Context.Notifications.error("We could not remove this list item at this time. Please try again later.");
          }
        });
      }
    }
    return false;
  },

  updateRating: function() {
    if (this.editing)
      return;
    this.model.save();
  },

  saveAndRender: function() {
    if (this.editing)
      return;
    this.model.save();
    this.render();
  },

  updateOwned: function(event) {
    if (this.editing)
      return;
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
