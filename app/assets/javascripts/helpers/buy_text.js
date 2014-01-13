Handlebars.registerHelper('buyText', function(listItem) {
  var text = "Buy ";

  if (listItem.age == "Pre-birth") {
    text += " " + listItem.age;
  } else {
    text += "at " + listItem.age;
  }
  text += ".";

  return new Handlebars.SafeString(text);
});
