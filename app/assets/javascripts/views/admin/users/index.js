Mamajamas.Views.Admin.UsersIndex = Backbone.View.extend({

  notes: {},

  initialize: function() {
    var _view = this;

    $(".users-list .bt-become").click(function(event) {
      return confirm("Are you sure you want to impersonate this user?");
    });
    $(".users-list .bt-user-delete").click(function(event) {
      return confirm("Are you sure you want to delete this user?");
    });

    this.cacheNotesRows();

    $("#users-table")
      .bind('sort', function() { _view.showNotesRows(_view) })
      .dataTable({
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

  cacheNotesRows: function() {
    var _view = this;
    $("#users-table .user-row").each(function() {
      var $row = $(this);
      var $rowmore = $row.next('.user-notes-row');

      if($rowmore.length > 0){
        _view.notes[$row.data('user-id')] = $rowmore.clone();
      }
    });

    $('.user-notes-row').remove();
  },

  showNotesRows: function(view) {
    $("#users-table .user-row").each(function() {
      var $row = $(this);
      if (view.notes[$row.data('user-id')]) {
        _.defer(function() {
          view.notes[$row.data('user-id')].toggle().insertAfter($row);
        });
      }
    });
  },

});
