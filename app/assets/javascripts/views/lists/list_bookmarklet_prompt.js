Mamajamas.Views.ListBookmarkletPrompt = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/bookmarklet_prompt'],

  className: 'modal-win',

  initialize: function() {
    this.$el.attr('id', 'bookmark-modal');
    this.$el.css({ display: 'none' });
  },

  render: function() {
    this.$el.html(this.template);
    return this;
  },

  events: {
    'click .bookmark-help': 'showHelp',
    'click .bookmark-modal-return': 'showDrag'
  },

  show: function() {
    var _view = this;
    var $img = $('#btbookmark').clone().css('display', '');
    var $bookmarkletLink = $('.bookmarklet-link', _view.$el);
    $bookmarkletLink.html($img);

    this.showDrag();

    this.$el.modal({
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
      overlayClose: true,
      onClose: function(dialog) {
        this.close(); // this is the modal
        _view.$el.remove();
      }
    });
  },

  close: function(event) {
    if (event) event.preventDefault();
    $.modal.close();
    return false;
  },

  showDrag: function(event) {
    if (event) event.preventDefault();
    this.setContent('drag-target', 'bookmark-modal', 435);
    return false;
  },

  showHelp: function() {
    if (event) event.preventDefault();
    this.setContent('help-target', 'bookmark-modal-help', 478);
    return false;
  },

  setContent: function(className, id, size) {
    $('.content', this.$el).html($('.' + className).html())
    this.$el.attr('id', id);
    this.$el.css('height', size + 'px');
  },

});
