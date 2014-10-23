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

  initialize: function() {
    this.collection.on('reset', this.render, this);

    this.initCollapsibles();
    this.initCopier();

    // since the privacy options are not contained in this.$el, we
    // will wire the events up manually
    this.currentPrivacy = parseInt($("input[name=privacy]:checked").val());
    this.hideOwned = this.currentPrivacy == this.privacyWantOnly;
    $("input[name=privacy]").on("change", $.proxy(this.updatePrivacy, this));

    if ($("#friends-modal").length > 0) {
      $('#friends-modal').modal({
        position: ["15%", null],
        closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
        overlayClose: true
      });
    }

    // setup social links
    new Mamajamas.Views.SocialLinks({
      el: '#social-links'
    });
  },

  events: {
    "click .listsort .choicedrop.list-sort a": "toggleSortList",
    "click .listsort .choicedrop.list-sort ol li a": "sort",
    "click .listsort .choicedrop.list-age-filter a": "toggleAgeFilterList",
    "click .listsort .choicedrop.list-age-filter ul li a": "ageFilter",
  },

  render: function() {
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
    if (this.hideOwned && item.get("owned"))
      return;
    if (this.filter && item.get("age") != this.filter) {
      return;
    }
    var view = new Mamajamas.Views.PublicListItemShow({
      model: item
    });
    $(this.$priorityContainer(priority)).append(view.render().$el);
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
    (filterName === "All ages") ? this.filter = null : this.filter = filterName;

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
      var $a = $("<a>").attr("href", "#").addClass("button").html("Copy List")
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

  $priorityContainer: function(priority) {
    var container = this.priorityContainers[priority];
    if (container == null) {
      container = $(this.prioritySelectors[priority]);
      this.priorityContainers[priority] = container;
    }
    return container;
  },

});
