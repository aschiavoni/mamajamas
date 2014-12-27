Mamajamas.Views.PublicListShow = Mamajamas.Views.Base.extend({

  priorityContainers: {},

  prioritySelectors: {
    1: "div.priority-high",
    2: "div.priority-med",
    3: "div.priority-low"
  },

  currentPrivacy: null,

  hideOwned: false,

  privacyWantOnly: 3,

  filter: null,

  ownerName: null,

  registry: null,

  initialize: function() {
    this.filter = $.cookies.get('public_registry_filter') || "Available";
    this.collection.on('reset', this.render, this);

    this.initCollapsibles();
    this.initCopier();

    // since the privacy options are not contained in this.$el, we
    // will wire the events up manually
    this.currentPrivacy = parseInt($("input[name=privacy]:checked").val());
    this.hideOwned = this.currentPrivacy == this.privacyWantOnly;
    $("input[name=privacy]").on("change", $.proxy(this.updatePrivacy, this));

    // setup social links
    new Mamajamas.Views.SocialLinks({
      el: '#social-links'
    });

    if ($('#details-link').length > 0) {
      $('#details-link a').click(function(event) {
        event.preventDefault();
        this.toggleDetails();
        return false;
      }.bind(this));
    }
  },

  events: {
    "click .listsort .choicedrop.list-sort a": "toggleSortList",
    "click .listsort .choicedrop.list-sort ol li a": "sort",
    "click .listsort .choicedrop.list-available-filter a": "toggleAvailableFilterList",
    "click .listsort .choicedrop.list-available-filter ul li a": "availableFilter"
  },

  render: function() {
    if (this.filter) {
      $('.list-available-filter > a', this.$el).html(
        this.filter + " <span class=\"ss-dropdown\"></span>"
      );
    }

    this.ownerName = Mamajamas.Context.List.get('owner_name');
    this.registry = Mamajamas.Context.List.get('registry');
    this.clearList();
    this.collection.each(this.appendItem, this);
    this.initExpandables();
    return this;
  },

  clearList: function() {
    $("#public-list div.collapsible-content").empty();
  },

  appendItem: function(item) {
    var priority = item.get("priority");
    var ownerName = this.ownerName;
    var isRegistry = this.registry;

    if (this.isFiltered(item))
      return;
    if (this.hideOwned && item.get("owned"))
      return;

    item.set('ownerName', ownerName);
    item.set('registry', isRegistry);
    var view = new Mamajamas.Views.PublicListItemShow({
      model: item
    });
    $(this.$priorityContainer(priority)).append(view.render().$el);
  },

  isFiltered: function(item) {
    if (this.filter) {
      if (this.filter === "Available" && item.get('desired_quantity') <= 0)
        return true;
      else if (this.filter === "Not available" && item.get('desired_quantity') != 0) {
        return true;
      } else {
        return false;
      }

    }
    return false;
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
    var sortBy = $sortLink.data("sort");
    $sortDisplay.html(sortName + " <span class=\"ss-dropdown\"></span>");
    this.collection.changeSort(sortBy);
    this.collection.sort();
  },

  toggleAvailableFilterList: function(event) {
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

  availableFilter: function(event) {
    var $filterLink = $(event.currentTarget);
    var filterName = $filterLink.html();
    var $filterDisplay = $filterLink.parents(".choicedrop").children("a");
    $filterDisplay.html(filterName + " <span class=\"ss-dropdown\"></span>");
    this.filter = filterName;
    $.cookies.set('public_registry_filter', this.filter);

    this.render();
  },

  initCollapsibles: function() {
    $('.priority.collapsible, .preview-msg .collapsible').collapsible({
      cssClose: 'ss-directright',
      cssOpen: 'ss-dropdown',
      defaultOpen: 'priority-high-hed,priority-med-hed,priority-low-hed',
      bind: 'click',
      speed:200
    });

    $('.priority.collapsible').each(function(index, e) {
      var $c = $(e);
      var $items = $c.next(".collapsible-content").children("div.prod");
      if ($items.length == 0) {
        $c.collapsible("close");
      }
    });
  },

  initExpandables: function() {
    // make all notes expandable
    $("div.expandable", this.$el).expander('destroy').expander({
      expandPrefix:     '... ',
      expandText:       'Expand', // default is 'read more'
      userCollapseText: 'Collapse',  // default is 'read less'
      expandEffect: 'show',
      expandSpeed: 0,
      collapseEffect: 'hide',
      collapseSpeed: 0,
      slicePoint: 265
    });
  },

  initCopier: function() {
    var _view = this;
    if (_view.isAuthenticated() && _view.userHasList() &&
        _view.model.get("owner_id") != Mamajamas.Context.User.get("id")) {
      var $a = $("<a>").attr("href", "#").addClass("button").html("Copy Registry")
      $("#subhed h2").after($a);
      $a.click(function(event) {
        event.preventDefault();
        _view.showProgress();

        $.post("/list/copy", {
          source: _view.model.get("id")
        }).done(function(result) {
          window.location = "/list";
        }).fail(function() {
          Mamajamas.Context.Notifications.error("We could not copy this list right now. Please try again later.");
        }).always(function() {
          _view.hideProgress();
        });
        return false;
      });
    }
  },

  updatePrivacy: function(event) {
    var $selected = $(event.currentTarget);
    var newPrivacy = parseInt($selected.val());

    if (this.currentPrivacy != newPrivacy) {
      if (newPrivacy == this.privacyWantOnly) {
        this.hideOwned = true;
        this.render();
      } else if (this.currentPrivacy == this.privacyWantOnly) {
        this.hideOwned = false;
        this.render();
      }
      this.currentPrivacy = newPrivacy;
    }
  },

  toggleDetails: function() {
    var $details = $('#listdetails');
    $details.toggle();
  },

  $priorityContainer: function(priority) {
    var container = this.priorityContainers[priority];
    if (container == null) {
      container = $(this.prioritySelectors[priority]);
      this.priorityContainers[priority] = container;
    }
    return container;
  },

});
