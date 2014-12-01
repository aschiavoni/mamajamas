Mamajamas.Views.ListItemAdded = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['list_items/added'],

  className: "modal-win",

  itemView: null,

  listItem: null,

  saved: false,

  initialize: function() {
    this.$el.attr("id", "needhave-modal");
  },

  events: {
  },

  render: function() {
    var template;
    if (this.model) {
      template = this.template( this.model.toJSON() );
    } else {
      template = this.template();
    }
    this.$el.html(template);

    this.inFieldLabels();
    // subviews
    var ratingView = new Mamajamas.Views.ListItemRating({
      model: this.model
    });
    $("div.rating", this.$el).append(ratingView.render().$el);

    var desiredQuantityView = new Mamajamas.Views.ListItemQuantity({
      model: this.model,
      quantityField: "desired_quantity",
      quantityLabel: "Want",
      minimum: 1
    });
    $(".frm-added > .own", this.$el).append(desiredQuantityView.render().$el);

    var ownedQuantityView = new Mamajamas.Views.ListItemQuantity({
      model: this.model,
      quantityField: "owned_quantity",
      quantityLabel: "Have"
    });
    $(".frm-added > .own", this.$el).append(ownedQuantityView.render().$el);

    this.initializeState();
    return this;
  },

  show: function(listItem) {
    var _view = this;

    this.itemView = $("#" + listItem.id);
    this.listItem = listItem;
    this.model = listItem.clone();
    this.render();

    var pos = this.position();
    this.$el.modal({
      closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
      overlayClose: true,
      opacity: 0,
      position: [ pos[0] + "px", pos[1] ],
      onClose: function(dialog) {
        _view.trigger("list_item:added:closed", _view, _view.saved);
        _view.saved = false;
        _view.$el.remove();
        _view.unbindEvents();
        this.close(); // this is the modal
      }
    });
  },

  close: function(event) {
    event.preventDefault();
    $.modal.close();
    return false;
  },

  save: function(event) {
    event.preventDefault();
    var _view = event.data;
    var attribs = {
      owned: _view.model.get("owned"),
      desired_quantity: _view.model.get("desired_quantity"),
      owned_quantity: _view.model.get("owned_quantity"),
      rating: _view.model.get("rating"),
      notes: $("textarea", _view.$el).val(),
    }
    _view.setNoShow();
    _view.listItem.set(attribs);
    _view.saved = true;
    _view.close(event);
    return false;
  },

  initializeState: function() {
    this.bindEvents();
    this.toggleRatingAndNotes();
  },

  toggleRatingAndNotes: function() {
    if (this.model.get("owned")) {
      $(".rating", this.$el).show();
      if (this.model.get("rating") > 0) {
        $(".prod-note", this.$el).show();
        $("textarea", this.$el).focus();
      }
    } else {
      $(".rating", this.$el).hide();
      $(".prod-note", this.$el).hide();
    }
  },

  setNoShow: function() {
    var $target = $("#needhave-noshow", this.$el);
    $.cookies.set("no_show_added", $target.is(":checked"), { path: "/" });
  },

  position: function() {
    var $prodDesc = $(".prod-desc", this.itemView);
    var offset = $prodDesc.offset();
    var positionTop = offset.top;

    return [ positionTop, "40%" ];
  },

  updateOffsets: function(event) {
    var _view = event.data;
    var pos = _view.position();
    var $modalContainer = _view.$el.parents(".simplemodal-container");
    var $close = $(".bt-close", $modalContainer);
    _view.$el.offset({ top: pos[0] });
    $close.offset({ top: (pos[0] + 11 )}).zIndex(_view.$el.zIndex() + 1);
  },

  inFieldLabels: function() {
    _.defer(function() {
      $("label", this.$el).inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
    });
  },

  bindEvents: function() {
    // bind events manually since the element behind this view can
    // often be destroyed and recreated
    $(window).on("scroll", null, this, this.updateOffsets);
    $(".cancel-modal", this.$el).on('click', null, this, this.close);
    $(".save-added-item", this.$el).on('click', null, this, this.save);
    $(".frm-added", this.$el).on('submit', null, this, this.save);
    this.model.on("change:owned", this.toggleRatingAndNotes, this);
    this.model.on("change:rating", this.toggleRatingAndNotes, this);
  },

  unbindEvents: function() {
    $(".cancel-modal", this.$el).off('click', null, this.close);
    $(".save-added-item", this.$el).off('click', null, this.save);
    $(".frm-added", this.$el).off('submit', null, this.save);
    this.model.off("change:owned", this.toggleRatingAndNotes, this);
    this.model.off("change:rating", this.toggleRatingAndNotes, this);
    $(window).off("scroll", this.updateOffsets);
  },

});
