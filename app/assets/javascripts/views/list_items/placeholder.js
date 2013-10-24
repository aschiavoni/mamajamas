Mamajamas.Views.ListItemPlaceholder = Mamajamas.Views.Base.extend({

  tagName: "div",

  template: HandlebarsTemplates["list_items/placeholder"],

  className: "prod clearfix",

  initialize: function() {
    this.$el.attr("id", this.model.get("id"));
  },

  events: {
    "click .find-item.button": "findItemClicked",
    "click .prod-edit-menu .delete": "delete",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));

    if (this.model.get('show_chooser'))
      _.defer(this.findItem, this);

    return this;
  },

  findItem: function(_view) {
    _view.setCurrentPosition();
    _view.model.set('show_chooser', false);
    var search = new Mamajamas.Views.ListItemSearch({
      model: _view.model
    });
    $('#buildlist').after(search.render().$el);
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
    return false;
  },

});
