Mamajamas.Views.ListShow = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/show'],

  initialize: function() {
    this.indexView = new Mamajamas.Views.ListItemsIndex({
      collection: Mamajamas.Context.ListItems
    });

    var _view = this;

    $('#bt-share, #bt-share-header').click(function(event) {
      if (Mamajamas.Context.List.get('item_count') == 0) {
        event.preventDefault();
        return false;
      }

      if (_view.isGuestUser()) {
        var link = $(event.currentTarget).attr("href");
        _view.unauthorized(link);
        return false;
      }
      return true;
    });

    $('#find-moms, .find-moms').click(function(event) {
      if (_view.isGuestUser()) {
        var link = $(event.currentTarget).attr("href");
        _view.unauthorized(link);
        return false
      }
      return true;
    });

    this.model.on('change:item_count', function() {
      var shareButton = $('#bt-share');
      var shareButonHeader = $('#bt-share-header');
      if (this.model.get('item_count') > 0) {
        shareButton.removeClass('disabled');
        shareButonHeader.attr('href', "/profile")
      } else {
        shareButton.addClass('disabled');
        shareButonHeader.attr('href', "/list")
      }
    }, this);
  },

  events: {
    "click .listsort .choicedrop a": "toggleSortList",
    "click .listsort .choicedrop ol li a": "sort",
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    $(this.$el).append(this.indexView.render().$el);

    if ($("#add-list-item").length > 0)
      _.defer(this.addToMyList, this);

    return this;
  },

  addToMyList: function(_view) {
    $.cookies.set("add_to_my_list", null);
    var listItemAttrs = $("#add-list-item").data("add-list-item");
    listItemAttrs["edit_mode"] = true;
    // var editView = new Mamajamas.Views.ListItemEdit({
    //   model: new Mamajamas.Models.ListItem(listItemAttrs)
    // });
    // $("#list-items").prepend(editView.render().$el);
    Mamajamas.Context.ListItems.add(listItemAttrs);
  },

  toggleSortList: function(event) {
    var $target = $(event.currentTarget);
    var $choiceDrop = $target.parents(".choicedrop");
    var $list = $choiceDrop.find("ol");

    if ($list.is(":visible")) {
      $list.hide();
    } else {
      $list.show();
    }

    return false;
  },

  sort: function(event) {
    var $sortLink = $(event.currentTarget);
    var sortName = $sortLink.html();
    var $sortDisplay = $sortLink.parents(".choicedrop").children("a");
    $sortDisplay.html(sortName + " <span class=\"ss-dropdown\"></span>");
    return this.indexView.sort(event);
  },

});
