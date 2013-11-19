Handlebars.registerHelper('haveNeed', function(owned) {
  var result = owned ? "have" : "need";
  return new Handlebars.SafeString(result);
});
