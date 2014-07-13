jQuery.fn.highlight = function () {
  $(this).each(function () {
    var el = $(this);
    $("<div/>")
      .width(el.outerWidth())
      .height(el.outerHeight())
      .css({
        "position": "absolute",
        "left": el.offset().left,
        "top": el.offset().top,
        "background-color": "#ffff99",
        "opacity": ".7",
        "z-index": "9999999"
      }).appendTo('body').fadeOut(1000).queue(function () { $(this).remove(); });
  });
}

jQuery.fn.rating = function() {
  var ratingEnabled = false;
  var readOnly = false;
  var $rating = $(this);

  var getRating = function() {
    return $rating.data('rating');
  };

  var setRating = function(rating) {
    $rating.data('rating', rating);
  };

  var enableRating = function(event) {
    ratingEnabled = true;
  };

  var restoreRating = function() {
    var rating = getRating();
    if (rating) {
      $(".star", $rating).each(function(idx, el) {
        var $star = $(el);
        if ($star.data("rating").toString() === rating.toString()) {
          $star.prevAll().andSelf().addClass("star-full");
          $star.nextAll().removeClass("star-full");
          return false;
        }
      });
    }
  };

  var disableRating = function(event) {
    ratingEnabled = false;
    restoreRating();
  };

  var highlight = function(event) {
    if (!ratingEnabled || readOnly)
      return true;

    var $star = $(event.target);
    $star.prevAll().andSelf().addClass("star-full");
    $star.nextAll().removeClass("star-full");
  };

  var unhighlight = function(event) {
    if (!ratingEnabled || readOnly)
      return true;
    var $star = $(event.target);
    $star.prevAll().andSelf().removeClass("star-full");
  };

  var rate = function(event) {
    if (readOnly)
      return true;
    var $star = $(event.target);
    var rating = $star.data("rating");
    setRating(rating);
  };

  $rating.mouseenter(enableRating);
  $rating.mouseleave(disableRating);
  $('.star', $rating).mouseenter(highlight);
  $('.star', $rating).mouseleave(unhighlight);
  $('.star', $rating).click(rate);

  return $rating;
}
