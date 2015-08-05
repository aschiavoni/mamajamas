Handlebars.registerHelper('haveNeed', function(owned) {
  var result = owned ? "have" : "want";
  return new Handlebars.SafeString(result);
});
