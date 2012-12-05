Handlebars.registerHelper('priorityIndicator', function(priority) {
  var className = null;

  switch(priority) {
    case 1:
      className = "priority-high";
      break;
    case 2:
      className = "priority-med";
      break;
    default:
      className = "priority-low";
  }

  var div = "<div class=\"priority-display " + className + "\">" + priority + "</div>";
  return new Handlebars.SafeString(div);
});
