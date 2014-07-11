var Mamajamas = Mamajamas || {};

Mamajamas.bookmarklet = (function() {

  var initialize = function() {
    initializeMessaging();
    initializeCategories();

    // update product types dropdown when category selection changes
    $('#additem-field-cat').change(updateProductTypes);

    // wire up close button
    $('a.bt-close').click(close);

    // populate from parent window
    $('body').on('populate', populate);

    trigger('populate-iframe');
  };

  var populateSelect = function($select, options) {
    $select.find('option').remove();
    _.each(options, function(element, index, list) {
      var $opt = $('<option/>').val(element.id).text(element.name);
      if (index === 0) $opt.prop('selected', true);
      $select.append($opt);
    });
  };

  var getCategories = function() {
    return $('#categories').data('categories');
  };

  var trigger = function(eventName) {
    $('body').trigger('post-message', [{
      event: eventName
    }]);
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

  var initializeCategories = function() {
    var categories = getCategories();
    var category = _.first(categories);

    populateSelect($('#additem-field-cat'), categories);
    populateSelect($('#additem-field-type'), category.product_types);
  };

  var updateProductTypes = function(event) {
    var $select = $(event.target);
    var categoryId = $select.val();
    var categories = getCategories();

    var category = _.find(categories, function(c) {
      return c.id.toString() === categoryId.toString();
    });

    if (category)
      populateSelect($('#additem-field-type'), category.product_types);
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
