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
        _view.unauthorized("/profile");
        return false;
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
    "click .listsort .choicedrop.list-sort a": "toggleSortList",
    "click .listsort .choicedrop.list-sort ol li a": "sort",
    "click .listsort .choicedrop.list-age-filter a": "toggleAgeFilterList",
    "click .listsort .choicedrop.list-age-filter ul li a": "ageFilter",
    "click #prod-rec": "clearRecommendedItems",
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    $(this.$el).append(this.indexView.render().$el);

    if ($("#add-list-item").length > 0)
      _.defer(this.addToMyList, this);

    // Dock the header to the top of the window when scrolled past the
    // banner.
    $('#title').scrollToFixed();
    $('#primary').scrollToFixed({
      marginTop: $('#title').outerHeight(true)
    });

    return this;
  },

  addToMyList: function(_view) {
    $.cookies.set("add_to_my_list", null);
    var listItemAttrs = $("#add-list-item").data("add-list-item");
    listItemAttrs["edit_mode"] = true;
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

  toggleAgeFilterList: function(event) {
    var $target = $(event.currentTarget);
    var $choiceDrop = $target.parents(".choicedrop");
    var $list = $choiceDrop.find("ul");

    if ($list.is(":visible")) {
      $list.hide();
    } else {
      $list.show();
    }

    return false;
  },

  ageFilter: function(event) {
    var $filterLink = $(event.currentTarget);
    var filterName = $filterLink.html();
    var $filterDisplay = $filterLink.parents(".choicedrop").children("a");
    $filterDisplay.html(filterName + " <span class=\"ss-dropdown\"></span>");
    return this.indexView.ageFilter(event);
  },

  clearRecommendedItems: function(event) {
    event.preventDefault();
    m = "Are you sure you want to clear all recommended items from your list?";
    if (confirm(m)) {
      var $target = $(event.currentTarget);
      var $form = $target.parents('form.clear-recommended');
      var authToken = $("meta[name=csrf-token]").attr('content');
      $('input', $form).val(authToken);
      $form.submit();
    }

    return false;
  },

});
