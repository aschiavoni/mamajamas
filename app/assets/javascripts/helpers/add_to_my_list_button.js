Handlebars.registerHelper('addToMyListButton', function(priority) {
  if (Mamajamas.Context.User && Mamajamas.Context.User.get('has_list')) {
    var btn = "<a href=\"/list/all\" target=\"_blank\" class=\"button bt-color bt-add\" title=\"Add to my list\"><span class=\"ss-plus\"></span><strong>Add</strong></a>"
    return new Handlebars.SafeString(btn);
  }
});
