Mamajamas.Views.GiftList = Mamajamas.Views.Base.extend({

  initialize: function() {
  },

  events: {
    "click .confirm-button": "confirm",
    "click .reset-button": "reset",
  },

  render: function() {
    return this;
  },

  confirm: function(event) {
    event.preventDefault(event);
    var giftId = $(event.currentTarget).
      parents("tr").
      attr("id").
      replace("gift-", "");
    this.updatePurchased(giftId, true);
    return false;
  },

  reset: function(event) {
    event.preventDefault(event);
    var giftId = $(event.currentTarget).
      parents("tr").
      attr("id").
      replace("gift-", "");
    this.updatePurchased(giftId, false);
    return false;
  },

  updatePurchased: function(giftId, purchased) {
    var listItemId = this.$el.data('list-item-id');
    $.ajax({
      url: '/api/gifts/' + giftId + '.json',
      type: 'PUT',
      data: {
        list_item_id: listItemId,
        gift: {
          purchased: purchased
        }
      },
      success: function(data, status, xhr) {
        if (!data.purchased) {
          $('#gift-' + data.id).remove();
        }
      },
      error: function(response, status, error) {
        Mamajamas.Context.Notifications.error('Please try again later.');
      },
      complete: function() {
      }
    });
  }

});
