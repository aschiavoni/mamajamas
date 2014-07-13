Mamajamas.Views.ListHelpModals = Mamajamas.Views.Base.extend({

  defaultTemplate: HandlebarsTemplates['lists/help_modals'],

  recommendedTemplate: HandlebarsTemplates['lists/help_modals_recommended'],

  className: "modal-dark",

  initialize: function() {
    this.$el.attr("id", "listintro");
    this.$el.css({ display: "none" });
  },

  events: {
    'click .bt-done': 'close'
  },

  render: function() {
    var template = this.defaultTemplate;
    if (Mamajamas.Context.User.get("build_custom_list") != true) {
      template = this.recommendedTemplate;
      $("#listintro-container").css("top", "225px");
    }
    this.$el.html(template);
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
        _view.close(); // this is the modal
        $(".info-balloon").remove();
        _view.$el.remove();
        $("#listintro").remove();
        if (Mamajamas.Context.List.get("item_count") == 0)
          $("#bt-share").addClass("disabled");
      }
    });
    if (Mamajamas.Context.User.get("build_custom_list") == true)
      this.showTips();
  },

  close: function(event) {
    if (event) event.preventDefault();
    $.modal.close();

    // show the bookmarklet prompt
    var bookmarkletPrompt = new Mamajamas.Views.ListBookmarkletPrompt();
    $('body').append(bookmarkletPrompt.render().$el);
    bookmarkletPrompt.show();

    return false;
  },

  showTips: function() {
    var $firstItem = $("#my-list div.prod").first();
    var $choose = $(".prod-links a.find-item", $firstItem);
    $choose.after($("#choose-balloon", this.$el).html())
      .parent("li").addClass("info-element");
  },

});
