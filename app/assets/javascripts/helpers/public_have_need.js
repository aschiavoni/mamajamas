Handlebars.registerHelper('publicHaveNeed', function(owned) {
  var result = owned ? "Has" : "Wants";
  return new Handlebars.SafeString(result);
});
