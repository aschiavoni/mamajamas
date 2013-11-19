Handlebars.registerHelper('priorityIndicator', function(priority) {
  var name = null;

  switch(priority) {
    case 1:
      name = "Must-Have";
      break;
    case 2:
      name = "Consider";
      break;
    default:
      name = "Don't Bother";
  }

  return new Handlebars.SafeString(name);
});
