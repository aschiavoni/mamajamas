var Mamajamas = Mamajamas || {};

Mamajamas.bookmarklet = (function() {
  var sliderContainer = null;

  var content = {
    form: {
      height: '429px',
      selector: 'form'
    },
    loggedOut: {
      height: '144px'
    },
    thanks: {
      height: '92px',
      selector: '#thanks'
    },
    loading: {
      height: '66px',
      selector: '#loading'
    },
    errors: {
      height: '78px',
      selector: '#errors'
    },
  }

  var signedIn = function() {
    return (typeof Mamajamas.Context.User != 'undefined');
  };

  var initialize = function() {
    initializeMessaging();
    if (signedIn()) {
      // update product types dropdown when category selection changes
      $('#additem-field-cat').change(updateProductTypes);
      $('form').submit(beforeSubmit);

      // init rating
      $('.rating').rating();

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

  var setRating = function() {
    var rating = $('.rating').data('rating');
    $('#list_item_rating').val(rating);
  };

  var setImageUrl = function() {
    if (sliderContainer) {
      // get active slide
      var $active = sliderContainer.find('li.active-slide');
      if ($active.length == 0) {
        // no sliding has occurred. by default, the 2nd li is the visible one
        $active = sliderContainer.find('li:nth-child(2)');
      }

      var $img = $active.children('img');
      $('#list_item_image_url').val($img.attr('src'));
    }
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
      pager: false,
      onSlideBefore: function($slideElem, oldIndex, newIndex) {
        $('.bxslider').children().removeClass('active-slide');
        $slideElem.addClass('active-slide');
      }
    });

    // show the frame
    trigger('resize-iframe');
  };

  var close = function(event) {
    event.preventDefault();
    trigger('unload-bookmarklet');
  };

  var nameRequired = function() {
    var nameField = $('#additem-name');
    nameField.highlight();
    nameField.focus();
  };

  var valid = function() {
    var nameField = $('#additem-name');

    if (nameField.val().trim().length === 0) {
      nameRequired();
      return false;
    }

    return true;
  };

  var transitionView = function(from, to) {
    var fromContent = content[from];
    var toContent = content[to];
    var $from = $(fromContent.selector);
    var $to = $(toContent.selector);
    var newHeight = toContent.height;

    $from.animate({
      height: newHeight
    }, 200, function() {
      $from.hide();
      $to.show();
    });
  };

  var beforeSubmit = function(event) {
    event.preventDefault();

    setProductTypeName();
    setRating();
    setImageUrl();

    if (valid()) {
      var destView = 'thanks';
      transitionView('form', 'loading');
      $.post('/mjsb', $('form').serialize(), function(data) {
        if (data.errors) {
          if (data.errors.name) {
            nameRequired();
          }
          else {
            destView = 'errors';
          }
        } else {
          $('#view-link').attr('href', data.view_url);
        }
      }).fail(function() {
        destView = 'errors';
      }).always(function() {
        _.delay(transitionView, 600, 'loading', destView);
      });
    }

    return false;
  };

  return {
    init: initialize
  };

})();

$(document).ready(function() {
  Mamajamas.bookmarklet.init();
});
