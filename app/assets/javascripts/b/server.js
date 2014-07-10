var Mamajamas = Mamajamas || {};

Mamajamas.bookmarklet = (function() {

  var initialize = function() {
    initializeMessaging();

    // wire up close button
    $('a.bt-close').click(close);

    // populate from parent window
    $('body').on('populate', populate);

    trigger('populate-iframe');
  };

  var initializeMessaging = function() {
    // when client sends message
    window.addEventListener('message', function(e) {

      var data = e.data;

      // it's trying to trigger
      // an arbitrary custom event
      if(!!data && data.event) {
        $('body').trigger(data.event, data.args);
      }

    }, false);

    // proxy messages to the parent
    $(document).on('post-message', 'body', function(e, d) {
      window.parent.postMessage(d, '*');
    });
  };

  var trigger = function(eventName) {
    $('body').trigger('post-message', [{
      event: eventName
    }]);
  };

  var populate = function(event, data) {
    $('#additem-name').val(data.title);
    $('#additem-field-price').val(data.price);

    var sliderContainer = $('.bxslider');
    $.each(data.images, function(i, v) {
      sliderContainer.append($('<li>').
                             append($('<img>').
                                    attr('src', v)));
    });

    sliderContainer.bxSlider({
      touchEnabled: true,
      pager: false
    });

    // show the frame
    trigger('resize-iframe');
  };

  var close = function(event) {
    event.preventDefault();
    trigger('unload-bookmarklet');
  };

  return {
    init: initialize
  };

})();

$(document).ready(function() {
  Mamajamas.bookmarklet.init();
});
