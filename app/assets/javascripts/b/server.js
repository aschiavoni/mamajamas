var Mamajamas = Mamajamas || {};

Mamajamas.bookmarklet = (function() {
  var sliderContainer = null;

  var signedIn = function() {
    return (typeof Mamajamas.Context.User != 'undefined');
  };

  var initialize = function() {
    initializeMessaging();
    if (signedIn()) {
      // update product types dropdown when category selection changes
      $('#additem-field-cat').change(updateProductTypes);
      $('form').submit(beforeSubmit);

      // populate from parent window
      $('body').on('populate', populate);
      trigger('populate-iframe');
    } else {
      trigger('resize-iframe');
    }

    // wire up close button
    $('a.bt-close').click(close);
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

  var setProductTypeName = function() {
    var $select = $('#additem-field-type');
    var selected = $select.children('option:selected').text();
    $('#list_item_product_type_name').val(selected)
  };

  var setImageUrl = function() {
    var idx = sliderContainer.getCurrentSlide();
    var $img = sliderContainer.find('li:nth-child(' + (idx + 1) + ') img');

    $('#list_item_image_url').val($img.attr('src'));
  };

  var populate = function(event, data) {
    $('#additem-name').val(data.title);
    $('#additem-field-price').val(data.price);
    $('#list_item_link').val(data.url);

    sliderContainer = $('.bxslider');
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

  var beforeSubmit = function(event) {
    setProductTypeName();
    setImageUrl();
    return true;
  };

  return {
    init: initialize
  };

})();

$(document).ready(function() {
  Mamajamas.bookmarklet.init();
});
