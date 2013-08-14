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
    "change .prod-owned": "updateOwned",
    "click .find-item.button": "findItemClicked",
    "click .ss-delete": "delete",
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

    if (this.model.get('show_chooser'))
      _.defer(this.findItem, this);

    return this;
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

  findItem: function(_view) {
    if (_view.isGuestUser()) {
      _view.unauthorized();
    } else {
      Mamajamas.Context.ListItems.trigger("list:item:editing");
      _view.setCurrentPosition();
      _view.model.set('show_chooser', false);
      var search = new Mamajamas.Views.ListItemSearch({
        model: _view.model
      });
      $('#buildlist').after(search.render().$el);
    }
  },

  findItemClicked: function(event) {
    event.preventDefault();
    this.findItem(this);
    return false;
  },

  setCurrentPosition: function() {
    var curPos = $('#list-items tr').index(this.$el);
    Mamajamas.Context.List.set("current_position", curPos);
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
