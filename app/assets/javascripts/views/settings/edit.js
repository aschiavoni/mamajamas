Mamajamas.Views.Settings = Backbone.View.extend({

  initialize: function() {
    $(document).ready(function() {

      $("label").inFieldLabels({ fadeDuration:200,fadeOpacity:0.55 });
      $("#field-duedate").datepicker({
        changeMonth: true,
        changeYear: true,
        onChangeMonthYear: function(year, month, inst) {
          var date = $(this).datepicker('getDate');
          date.setFullYear(year);
          date.setMonth(month - 1);
          $(this).datepicker('setDate', date);
        }
      });
      $('#settings_unsubscribe_all').change(function() {
        console.log("toggleUnsubscribeAll");
        var $cb = $(event.currentTarget);
        if ($cb.prop('checked')) {
          $('#ind-emails').slideUp();
        } else {
          $('#ind-emails').slideDown();
        }
      });
      $('img.date-picker').click(function(event) {
        event.preventDefault();
        $("#field-duedate").datepicker("show");
        return false;
      });
    });
  }

});
