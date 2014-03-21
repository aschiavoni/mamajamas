Mamajamas.Views.ListItemNotes = Mamajamas.Views.Base.extend({

  tagName: 'div',

  template: HandlebarsTemplates['list_items/notes'],

  className: "prod-note",

  emptyClass: "prod-note_empty",

  editClass: "prod-note_edit",

  initialize: function() {
    if (!this.hasNotes())
      this.$el.addClass(this.emptyClass);
  },

  events: {
    "click .prod-note-trigger": "edit",
    "click .cancel-item": "cancel",
    "click .save-item": "save",
    "keyup textarea": "autoSaveNotes",
  },

  render: function() {
    this.$el.html(this.template({ listItem: this.model.toJSON() }));
    return this;
  },

  hasNotes: function() {
    var notes = this.model.get("notes");
    return notes != null && notes.length > 0;
  },

  inFieldLabels: function() {
    $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
  },

  notesField: function() {
    return $("#list_item_notes_" + this.model.id, this.$el);
  },

  edit: function(event) {
    var _view = this;
    _view.editMode();
  },

  save: function(event, rerender) {
    if (event)
      event.preventDefault();

    if (rerender != false)
      rerender = true;

    var _view = this;
    var notes = this.notesField().val();
    if (notes != null && notes.length === 0)
      notes = null;
    this.model.set("notes", notes);
    this.model.save({ notes: notes }, {
      wait: true,
      success: function() {
        if (rerender) {
          _view.viewMode();
          _view.render();
        }
      },
      error: function(model, response) {
        Mamajamas.Context.Notifications.error("We could not save your comment at this time. Please try again later.");
      }
    });
    return false;
  },

  autoSaveNotes: function(event) {
    var _view = this;
    _view.autoSave(_view);
    return true;
  },

  autoSave: _.debounce(function(_view) {
    _view.save(null, false);
  }, 3000, false),

  cancel: function(event) {
    this.emptyMode();
    return true;
  },

  editMode: function() {
    var _view = this;
    _view.$el.removeClass(_view.emptyClass).addClass(_view.editClass);
    _.defer(function() {
      _view.inFieldLabels();
      _view.notesField().focus();
    });
  },

  emptyMode: function() {
    var _view = this;
    _view.$el.removeClass(_view.editClass).addClass(_view.emptyClass);
    _.defer(function() {
      _view.notesField().blur();
      _view.inFieldLabels();
    });
  },

  viewMode: function() {
    this.emptyMode();
    this.$el.removeClass(this.emptyClass);
  },

});
