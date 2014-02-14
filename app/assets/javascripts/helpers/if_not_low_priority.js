Handlebars.registerHelper('ifNotLowPriority', function(listItem, options) {
  if (listItem.priority != 3) {
    return options.fn(this);
  }
});
