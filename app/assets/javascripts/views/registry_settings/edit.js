Mamajamas.Views.RegistrySettings = Backbone.View.extend({

  initialize: function() {
    $(document).ready(function() {
      //collapsible management
      $('.collapsible', this.$el).collapsible({
        defaultOpen: 'shippinghed',
        cssClose: 'panel-closed',
        cssOpen: 'panel-open',
        speed:200
      });
    });
  },

  events: {
  },

});
