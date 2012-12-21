// custom simple plugin to toggle a progress indicator
//
// Examples:
// $("#signup-modal, #login-modal").progressIndicator('show');
// $("#signup-modal, #login-modal").progressIndicator('hide');
//
// assumes markup like:
//
// <div class="progress-container">
//   <button type="reset" class="button" id="bt-cancel">Cancel</button>
//   <button type="submit" class="button" id="bt-log-in">Log in</button>
//   <%= image_tag("progress-bar.gif", :class => "progress", :style => "display: none;") %>
// </div>


(function($){
  var methods = {
    show: function() {
      var $progressContainer = $(".progress-container:not(.progress-disabled)");
      var $progress = $(".progress", $progressContainer);
      $progress.show().siblings().hide();
      return this;
    },
    hide: function() {
      var $progressContainer = $(".progress-container:not(.progress-disabled)");
      var $progress = $(".progress", $progressContainer);
      $progress.hide().siblings().show();
      return this;
    },
  };

  $.fn.progressIndicator = function( method ) {
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.progressIndicator' );
    }
  };

})( jQuery );
