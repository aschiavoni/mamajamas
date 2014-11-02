/** @jsx React.DOM */

Mamajamas.Views.ListShow = Mamajamas.Views.Base.extend({

  template: HandlebarsTemplates['lists/show'],

  inFieldLabelDefaults: {
    fadeDuration:200,
    fadeOpacity:0.55
  },

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
        _view.unauthorized("/registry");
        return false;
      }
      return true;
    });

    this.model.on('change:item_count', function() {
      var shareButton = $('#bt-share');
      var shareButonHeader = $('#bt-share-header');
      if (this.model.get('item_count') > 0) {
        shareButton.removeClass('disabled');
        shareButonHeader.attr('href', "/registry")
      } else {
        shareButton.addClass('disabled');
        shareButonHeader.attr('href', "/list")
      }
    }, this);

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

    if ($("#friends-modal").length > 0) {
      $('#friends-modal').modal({
        position: ["15%", null],
        closeHTML:'<a class="bt-close ss-icon" href="#">Close</a>',
        overlayClose: true
      });
    }
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

    this.initializeSorting();

    $(this.$el).append(this.indexView.render().$el);

    if ($("#add-list-item").length > 0)
      _.defer(this.addToMyList, this);

    React.renderComponent((
      <Mamajamas.Components.ListTitle
        model={this.model}
        inFieldLabelDefaults={this.inFieldLabelDefaults}
        onSave={this.save} />
    ), $('#subhed').get(0));

    return this;
  },

  save: function(attributes, successCb, errorCb) {
    this.model.store();

    this.model.save(attributes, {
      patch: true,
      success: successCb,
      error: function(model, response) {
        model.restore();
        var errors = $.parseJSON(response.responseText).errors;
        errorCb(errors);
      }.bind(this)
    });
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
    this.setSortDisplay(sortName);
    return this.indexView.sort(event);
  },

  setSortDisplay: function(name) {
    var $sortDisplay = $('.listsort .list-sort.choicedrop').children("a");
    $sortDisplay.html(name + " <span class=\"ss-dropdown\"></span>");
  },

  initializeSorting: function() {
    if (window.location.search.length > 0) {
      var params = {};
      window.location.search.substring(1).split('&').forEach(function(item) {
        var parts = item.split('=');
        params[parts[0]] = parts[1];
      });

      if (params.s) {
        var parts = params.s.split('');
        var sortDisplay = null;
        var sortBy = parts[0];
        var direction = parts[1];

        switch (sortBy) {
        case 'n':
          sortBy = 'name';
          sortDisplay = 'Name (A - Z)'
          break;
        case 'u':
          sortBy = 'updated_at';
          sortDisplay = 'Last Updated'
          break;
        case 'r':
          sortBy = 'rating';
          sortDisplay = 'Rating'
          break;
        case 'o':
          sortBy = 'owned';
          sortDisplay = 'Owned'
          break;
        case 'a':
          sortBy = 'age';
          sortDisplay = 'When to buy'
          break;
        case 'p':
          sortBy = 'priority';
          sortDisplay = 'Priority'
          break;
        default:
          sortBy = null;
          sortDisplay = null;
        }

        if (sortBy) {
          direction = direction == 'd' ? 'DESC' : 'ASC';
          this.indexView.sortCollection(sortBy, direction);
          _.defer(this.setSortDisplay, sortDisplay);
        }
      }
    }
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

    var $target = $(event.target);
    if ($target.prop('tagName').toLowerCase() == 'span') {
      $target.css('display', '').css('cursor: default');
      return false;
    }
    var view = this;
    view.showProgress();
    m = "This will clear all Mamajamas recommendations that you have not added, rated, or edited. You cannot get recommendations back once you clear them.\n\nAre you sure you want to clear all recommended items from your list?"

    _.delay(function() {
      if (confirm(m)) {
        var $target = $(event.currentTarget);
        var $form = $target.parents('form.clear-recommended');
        var authToken = $("meta[name=csrf-token]").attr('content');
        $('input', $form).val(authToken);
        $form.submit();
      } else {
        view.hideProgress();
      }
    }, 600);

    return false;
  },

  toggleDetails: function() {
    var $details = $('#listdetails');
    $details.toggle();
  },

});
