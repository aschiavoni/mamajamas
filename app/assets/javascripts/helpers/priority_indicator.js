Handlebars.registerHelper('priorityIndicator', function(priority) {
  var className = null;
  var title = null;

  switch(priority) {
    case 1:
      className = "priority-high";
      title = "Get it";
      break;
    case 2:
      className = "priority-med";
      title = "Consider it";
      break;
    default:
      className = "priority-low";
      title = "Don't bother";
  }

  var div = "<div class=\"priority-display " + className + "\" title=\"" + title + "\">" + priority + "</div>";
  return new Handlebars.SafeString(div);
});
