Mamajamas.Views.FriendsView = function (options) {
    this.padHeight = "20";
    this.targetElement = "",
    $(window).resize($.proxy(this.sizeContent, this));

    Backbone.View.apply(this, [options]);
};

_.extend(Mamajamas.Views.FriendsView.prototype, Backbone.View.prototype, {

  sizeContent: function() {
    var newHeight = $(window).height() - $("#hed-wrap").height() - $("#title").height() - $(".menu").height() - $("#footer").height() - this.padHeight + "px";
    $(this.targetElement).css("height", newHeight);
  }

});

Mamajamas.Views.FriendsView.extend = Backbone.View.extend;
