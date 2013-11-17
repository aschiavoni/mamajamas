Mamajamas.Views.ListItemShow = Mamajamas.Views.ListItem.extend({

  tagName: "div",

  template: HandlebarsTemplates["list_items/show"],

  className: "prod prod-filled clearfix",

  initialize: function() {
    this.editing = false;
    this.model.on("change:rating", this.update, this);
    this.model.on("change:owned", this.update, this);
    this.model.on("change:quantity", this.update, this);
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "click .prod-edit-menu .edit": "edit",
    "click .prod-edit-menu .delete": "delete",
    "click .prod-edit-menu .drag": "doNothing",
    "click .bt-addanother": "addAnother",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("div.rating", this.$el).append(ratingView.render().$el);

    var quantityView = new Mamajamas.Views.ListItemQuantity({
      model: this.model
    });
    $(".prod-when-own", this.$el).append(quantityView.render().$el);


    var notesView = new Mamajamas.Views.ListItemNotes({
      model: this.model
    });
    $("div.prod-when-own", this.$el).after(notesView.render().$el);

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

    return false;
  },

  addAnother: function(event) {
    event.preventDefault();
    this.editing = true;

    var searchView = new Mamajamas.Views.ListItemSearch({
      model: new Mamajamas.Models.ListItem({
        show_chooser: true,
        age: this.model.get('age'),
        age_position: this.model.get('age_position'),
        category: this.model.get('category'),
        category_id: this.model.get('category_id'),
        placeholder: true,
        priority: this.model.get('priority'),
        product_type_id: this.model.get('product_type_id'),
        product_type_name: this.model.get('product_type_name'),
        product_type_plural_name: this.model.get('product_type_plural_name'),
        image_url: this.model.get('product_type_image_name'),
        owned: false,
      })
    });

    $('#buildlist').after(searchView.render().$el);
    searchView.show();

    return false;
  },

  delete: function() {
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
    return false;
  },

  update: function() {
    if (this.editing)
      return;
    this.model.save();
  },

});
