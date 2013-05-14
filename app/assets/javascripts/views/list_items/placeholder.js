Mamajamas.Views.ListItemPlaceholder = Mamajamas.Views.Base.extend({

  tagName: 'tr',

  template: HandlebarsTemplates['list_items/placeholder'],

  className: "prod",

  initialize: function() {
    this.model.on("change:age", this.saveAndRender, this);
    this.model.on("change:priority", this.saveAndRender, this);
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    'click .find-item.button': 'findItem',
    'click .ss-delete': 'delete',
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

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

  saveAndRender: function() {
    this.model.save();
    this.render();
  },

  findItem: function(event) {
    event.preventDefault();

    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      var search = new Mamajamas.Views.ListItemSearch({
        model: this.model
      });
      $('#buildlist').after(search.render().$el);
    }

    return false;
  },

  // addItem: function(event) {
  //   if (this.isGuestUser()) {
  //     this.unauthorized();
  //   } else {
  //     var newItem = this.model.clone();
  //     newItem.id = null;
  //     newItem.set("name", null);
  //     var addItem = new Mamajamas.Views.ListItemEdit({
  //       model: newItem,
  //       parent: this
  //     });

  //     this.$el.after(addItem.render().$el);
  //     this.$el.hide();
  //     addItem.setup();
  //   }

  //   return false;
  // },

  // moveToBottom: function() {
  //   this.$el.appendTo("#list-items");
  //   this.$el.show();
  // },

  delete: function() {
    if (this.isGuestUser()) {
      this.unauthorized();
    } else {
      if (confirm("Are you sure you want to delete this item?")) {
        this.model.destroy({
          wait: true,
          success: function() {
            Mamajamas.Context.ListItems.remove(this.model);
          },
          error: function(model, response, options) {
            Mamajamas.Context.Notifications.error("We could not remove this item at this time. Please try again later.");
          }
        });
      }
    }
    return false;
  }

});
