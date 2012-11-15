Mamajamas.Views.ListShow = Backbone.View.extend({
  initialize: function() {
    _list = this;
    console.log("initializing ListShow...");
  },

  events: {
    "click .add-item.button": "addItem",
  },

  render: function(event) {
     return this;
  },

  addItem: function(event) {
    console.log("add item clicked.");

    var addItem = new Mamajamas.Views.ListItemsEdit({
      model: new Mamajamas.Models.ListItem()
    });
    var $prod = $(event.target).parents("tr.prod");
    $prod.replaceWith(addItem.render().$el);

    // TODO: this should go somewhere else
    $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    $("#field-prodname").focus();

    return false;
  }
});

