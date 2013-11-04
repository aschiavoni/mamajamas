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
    // "click #babygear th.own": "sort",
    // "click #babygear th.item": "sort",
    // "click #babygear th.when": "sort",
    // "click #babygear th.rating": "sort",
    // "click #babygear th.priority": "sort"
  },

  render: function() {
    this.clearList();
    this.collection.each(this.appendItem, this);
    this.initCollapsibles();
    this.initExpandables();
    return this;
  },

  clearList: function() {
    $("div.collapsible-content").empty();
  },

  appendItem: function(item) {
    var priority = item.get("priority");
    var view = new Mamajamas.Views.PublicListItemShow({
      model: item
    });
    $(this.$priorityContainer(priority)).append(view.render().$el);
  },

  sort: function(event) {
    var $header = $(event.target);
    $("#babygear th").removeClass("sorting");
    $header.addClass("sorting");

    var sortBy = $header.data("sort");

    this.collection.changeSort(sortBy);
    this.collection.sort();
  },

  initCollapsibles: function() {
    $('.priority.collapsible').collapsible({
      cssClose: 'ss-directright',
      cssOpen: 'ss-dropdown',
      defaultOpen: 'priority-high-hed,priority-med-hed',
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
