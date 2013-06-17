Mamajamas.Views.ListItemAddYourOwn = Mamajamas.Views.Base.extend({
  template: HandlebarsTemplates['list_items/add_your_own'],

  initialize: function() {
  },

  events: {
    'click .add-your-own-button': 'add'
  },

  render: function() {
    this.$el.html(this.template());
    _.defer(this.initCollapsible, this);
    return this;
  },

  initCollapsible: function(_view) {
    $('.collapsible', this.$el).collapsible({
      cssClose: 'ss-directright',
      cssOpen: 'ss-dropdown',
      speed:200,
      // these names are confusing
      // animateClose is actually called when the collapsible expands
      animateClose: _view.open,
      animateOpen: _view.close,
    });
  },

  nameField: function() {
    return $('#field-prodname', this.$el);
  },

  open: function(elem, opts) {
    var $content = elem.next();
    $content.slideDown(opts.speed, function() {
      $('#field-prodname', $content).focus();
    });
  },

  close: function(elem, opts) {
    elem.next().slideUp(opts.speed);
  },

  add: function(event) {
    event.preventDefault();
    var $field = this.nameField();
    $field.removeClass('error');

    var name = $field.val();
    if (name.length > 0) {
      this.model.set('name', name);
      this.model.set('url', null);
      this.trigger('search:product:added', this.model);
    } else {
      $field.addClass('error');
      $field.focus();
    }
    return false;
  },

});
