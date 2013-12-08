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
  },

  follow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var followedId = li.data("friend-id");

    var data = { relationship: { followed_id: followedId } };
    $.post('/relationships', data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

  unfollow: function(view) {
    var btn = $(view.currentTarget);
    var li = btn.parent("li");
    var relationshipId = li.data("relationship-id");

    var data = { _method: "delete" };
    $.post("/relationships/" + relationshipId, data, function(response) {
      li.replaceWith(response);
    })
    return false;
  },

  // this doesn't seem to work yet
  initializeScrolling: function() {
    // keep header, primary nav and list nav fixed and scroll the rest
    // of the page
    $("#hed-wrap").scrollToFixed();

    $("#primary").scrollToFixed({
      margintop: $('#hed-wrap').outerHeight(true)
    });

    $(".menu").scrollToFixed({
      margintop: $('#hed-wrap').outerHeight(true)
    });
  },

});

Mamajamas.Views.FriendsView.extend = Backbone.View.extend;
