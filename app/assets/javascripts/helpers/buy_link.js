Handlebars.registerHelper('buyLink', function(listItem) {
  var link = "<a target=\"_blank\" href=\"" + listItem.link + "\">Buy</a> "

  if (listItem.age == "Pre-birth") {
    link += " " + listItem.age;
  } else {
    link += "at " + listItem.age;
  }

  return new Handlebars.SafeString(link);
});
