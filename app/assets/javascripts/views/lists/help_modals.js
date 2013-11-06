Mamajamas.Views.ListHelpModals = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/help_modals'],

  className: "modal-dark",

  initialize: function() {
    this.$el.attr("id", "listintro");
    this.$el.css({ display: "none" });
  },

  events: {
    'click .bt-done': 'close'
  },

  render: function() {
    this.$el.html(this.template);
    return this;
  },

  show: function() {
    var _view = this;
    $("#bt-share").removeClass("disabled");
    this.$el.modal({
      containerId:'listintro-container',
      autoPosition:false,
      opacity:35,
      zIndex: 3000,
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
      onClose: function(dialog) {
        this.close(); // this is the modal
        $(".info-balloon").remove();
        _view.$el.remove();
        $("#listintro").remove();
        if (Mamajamas.Context.List.get("item_count") == 0)
          $("#bt-share").addClass("disabled");
      }
    });
    this.showTips();
  },

  close: function(event) {
    if (event)
      event.preventDefault();
    $.modal.close();
    return false;
  },

  showTips: function() {
    var $firstItem = $("#my-list div.prod").first();
    var $choose = $(".prod-links a.find-item", $firstItem);
    $choose.after($("#choose-balloon", this.$el).html())
      .parent("li").addClass("info-element");
  },

});
