// this is the interface for the parent window
// and the bookmarklet

$(function() {

  // when client sends message
  window.addEventListener('message', function(e) {

    var data = e.data;

    // it's trying to trigger
    // an arbitrary custom event
    if(!!data && data.event) {
      $('body').trigger(data.event, data.args);
    }

  }, false);

});

// example close button, which can communicate back with the bookmarklet code
$(function() {

  $('a.bt-close').click(function(e) {
    $(this).trigger('post-message', [{
      event: 'unload-bookmarklet'
    }]);
    e.preventDefault();
  });

});

$(document).on('post-message', 'body', function(e, d) {
  window.parent.postMessage(d, '*');
});


// show the bookmarklet the first time
$(document).ready(function() {
  $('body').trigger('post-message', [{
    event: 'resize-iframe'
  }]);
});
