Mamajamas.Views.PublicListShow = Backbone.View.extend({

  priorityContainers: {},

  prioritySelectors: {
    1: "div.priority-high",
    2: "div.priority-med",
    3: "div.priority-low"
  },

  initialize: function() {
    this.collection.on('reset', this.render, this);
  },

  events: {
    "click .listsort .choicedrop a": "toggleSortList",
    "click .listsort .choicedrop ol li a": "sort",
  },

  render: function() {
    this.clearList();
    this.collection.each(this.appendItem, this);
    this.initCollapsibles();
    this.initExpandables();
    return this;
  },

  clearList: function() {
    $("#public-list div.collapsible-content").empty();
  },

  appendItem: function(item) {
    var priority = item.get("priority");
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

  $priorityContainer: function(priority) {
    var container = this.priorityContainers[priority];
    if (container == null) {
      container = $(this.prioritySelectors[priority]);
      this.priorityContainers[priority] = container;
    }
    return container;
  },

});
