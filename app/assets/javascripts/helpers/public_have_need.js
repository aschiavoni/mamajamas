Handlebars.registerHelper('publicHaveNeed', function(owned) {
  var result = owned ? "Has" : "Needs";
  return new Handlebars.SafeString(result);
});
