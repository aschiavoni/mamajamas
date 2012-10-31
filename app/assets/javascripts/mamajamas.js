window.Mamajamas = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Context: {},
  initialize: function() {
    if ($("#follow-moms")) {
      new Mamajamas.Views.FriendPicker({
        el: '#follow-moms'
      });
    }
  }
};

$(document).ready(function() {
  return Mamajamas.initialize();
});
