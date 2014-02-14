Mamajamas.Views.ListItemsIndex = Backbone.View.extend({

  template: HandlebarsTemplates['list_items/index'],

  tagName: "div",

  className: "clearfix",

  prioritySelectors: {
    1: "div.priority-high",
    2: "div.priority-med",
    3: "div.priority-low"
  },

  priorityContainers: {},

  collapsiblesToReset: [],

  filter: null,

  initialize: function() {
    this.collection.on("reset", this.render, this);
    this.collection.on("add", this.insertItem, this);
    this.collection.on("remove", this.removeItem, this);
    this.$el.attr("id", "list-items");
  },

  events: {
    "click .new-item": "addProductType"
  },

  render: function() {
    this.priorityContainers = {};
    this.$el.html(this.template);
    this.collection.each(this.appendItem, this);
    this.initCollapsibles();
    this.initExpandables();
    this.initDraggables();

    if (Mamajamas.Context.List.get('view_count') == 0) {
      var helpModals = new Mamajamas.Views.ListHelpModals();
      $('body').append(helpModals.render().$el);
      helpModals.show();
    }

    return this;
  },

  initDraggables: function() {
    var _view = this;
    $("div.collapsible-content", this.el).sortable({
      axis: "y",
      // handle: ".drag",
      connectWith: "div.collapsible-content",
      dropOnEmpty: true,
      opacity: 1.0,
      placeholder: "edit-mode",
      forcePlaceholderSize: true,
      start: function(event, ui) {
        $(ui.item).css({ backgroundColor: "#FFFFFF" });
        _view.openCollapsibles();
      },
      stop: function(event, ui) {
        $(ui.item).css({ backgroundColor: "rgba(0, 0, 0, 0)" });
        _view.closeCollapsibles();
      },
      update: function(event, ui) {
        var $prod = $(ui.item);
        var $priorityContainer = $prod.parents(".collapsible-content");
        var newPriority = parseInt($priorityContainer.data("priority"));
        var listItem = _view.collection.get($prod.attr("id"));
        if (newPriority != listItem.get("priority")) {
          listItem.save({ priority: newPriority });
        }
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

  openCollapsibles: function() {
    var _view = this;
    $('.priority.collapsible').each(function(index, e) {
      var $c = $(e);
      if ($c.collapsible("collapsed")) {
        _view.collapsiblesToReset.push($c);
        $c.collapsible("open");
      }
    });
  },

  closeCollapsibles: function() {
    _.each(this.collapsiblesToReset, function($el) {
      var $items = $el.next(".collapsible-content").children("div.prod");
      if ($items.length == 0)
        $el.collapsible("close");
    });
    this.collapsiblesToReset = [];
  },

  insertItem: function(item, collection, options) {
    var $itemView = this.itemView(item).render().$el;
    var priority = item.get("priority");
    var insertAt = Mamajamas.Context.List.get("current_position");
    if (insertAt == 0) {
      this.$priorityContainer(priority).prepend($itemView);
    } else {
      var selector = this.prioritySelectors[priority];
      $(selector + " div.prod:nth-child(" + insertAt + ")").after($itemView);
    }
  },

  appendItem: function(item) {
    if (this.filter && item.get("age") != this.filter) {
      return;
    }
    var $itemView = this.itemView(item).render().$el;
    var priority = item.get("priority");
    $(this.$priorityContainer(priority)).append($itemView);
  },

  removeItem: function(item, items, options) {
    var $listItem = $("#" + item.get("id"), "#list-items");
    if ($listItem) {
      $listItem.remove();
    }
  },

  $priorityContainer: function(priority) {
    var container = this.priorityContainers[priority];
    if (container == null) {
      container = $(this.prioritySelectors[priority], this.$el);
      this.priorityContainers[priority] = container;
    }
    return container;
  },

  sort: function(event) {
    var $target = $(event.target);
    var sortBy = $target.data("sort");
    this.collection.changeSort(sortBy);
    this.collection.sort();
  },

  ageFilter: function(event) {
    var $target = $(event.target);
    var filterBy = $target.html();
    (filterBy === "All ages") ? this.filter = null : this.filter = filterBy;
    this.render();
  },

  itemView: function(item) {
    var view = null;
    if (item.get("placeholder")) {
      // Placeholder
      view = new Mamajamas.Views.ListItemPlaceholder({
        model: item
      });
    } else {
      // ListItem
      if (item.get("edit_mode") == true) {
        view = new Mamajamas.Views.ListItemEdit({
          model: item
        });
      } else if (item.get("new_mode") == true) {
        view = new Mamajamas.Views.ListItemNew({
          model: item
        });
      } else {
        view = new Mamajamas.Views.ListItemShow({
          model: item
        });
      }
    }
    return view;
  },

  addProductType: function(event) {
    event.preventDefault();

    var addItem = new Mamajamas.Views.ListItemNew({
      model: new Mamajamas.Models.ListItem({
        category_id: Mamajamas.Context.List.get("category_id"),
        age: "Pre-birth",
        priority: 2,
        quantity: 1,
        owned: false,
        image_url: "products/icons/unknown.png"
      })
    });
    addItem.on("list_item:new:closed", this.showAddNew, this);

    var $addNew = $("#add-new");
    $addNew.before(addItem.render().$el);
    $addNew.hide();

    return false;
  },

  showAddNew: function(view) {
    $("#add-new").show();
    view.off("list_item:new:closed");
  },

});
