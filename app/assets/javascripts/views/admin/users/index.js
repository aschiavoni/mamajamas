Mamajamas.Views.Admin.UsersIndex = Backbone.View.extend({

  initialize: function() {
    $(".users-list .bt-become").click(function(event) {
      return confirm("Are you sure you want to impersonate this user?");
    });
    $(".users-list .bt-user-delete").click(function(event) {
      return confirm("Are you sure you want to delete this user?");
    });
    $("#users-table").dataTable({
      "bPaginate": false,
      "bLengthChange": false,
      "bFilter": false,
      "bSort": true,
      "bInfo": false,
      "bAutoWidth": false,
      "aoColumnDefs": [
        { "bSortable": false, "aTargets": [2, 6] },
      ]
    });
  },

});
