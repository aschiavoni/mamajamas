Handlebars.registerHelper('assetPath', function(name) {
  var path = name;
  if (!path.match("^http"))
    path = Mamajamas.Context.AssetPath + name;
  return new Handlebars.SafeString(path);
});
