Handlebars.registerHelper('bookmarkletLink', function(text) {
  var $link = $('.bookmarklet-link');
  if ($link.length > 0) {
    var $newLink = $link.clone().css('display', '');
    $newLink.text(text);
    return new Handlebars.SafeString($newLink.wrap('<div/>').parent().html());
  }
  return null;
});
