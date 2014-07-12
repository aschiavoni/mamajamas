var mamajamas = (function() {

  // some things we need in here
  var host = 'http://localhost:3000/',
  iframeUrl = host + 'mjsb',
  $ = false,
  doc = document,
  head = doc.getElementsByTagName('head')[0],
  body = doc.getElementsByTagName('body')[0],
  messageListeners = [],
  iframe,
  container,
  channel;

  // general utils
  var Utils = {

    // load a javascript file
    loadJs: function(src) {
      var js = doc.createElement('script');
      js.type = 'text/javascript';
      js.src = src;
      js.async = true;
      head.appendChild(js);
    },

    addMessageListener: function(message, callback) {
      messageListeners[message] = callback;
    },

    // if jquery does not exist, load it
    // and callback when jquery is loaded
    loadJquery: function(cb) {
      // always load jquery because they might have
      // a prototyped version on page
      Utils.loadJs('http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js');
      // start checking every 100ms to see
      // if the jQuery object exists yet
      (function poll() {
        setTimeout(function() {
          // jquery exists, callback
          if(window.jQuery) {
            $ = window.jQuery;
            cb();
            // jquery doesn't exist,
            // keep trying
          } else {
            poll();
          }
        }, 100);
      })();
    }

  };

  var Product = function() {
    this.data = function() {
      return {
        title: findTitle(),
        price: findPrice(),
        images: findImages(),
        url: window.location.toString()
      }
    };

    this.hostname = extractHostname();

    function extractHostname() {
      var parts = window.location.hostname.split('.')
      if (parts.length > 2) parts.shift();
      return parts.join('.');
    }

    function findTitle() {
      var title;

      switch(this.hostname) {
        case 'amazon.com':
          title = $('#productTitle').text();
          break;
      }

      if (!title) {
        title = $('title').text();
        if (title) {
          title = title.split('|')[0].trim();
        }
      }

      return title;
    }

    function findPrice() {
      var price;

      switch(this.hostname) {
      }

      if (!price) {
        scraper = new Scraper();
        price = scraper.getPrice();
      }

      return price;
    }

    function findImages() {
      var images = $.map($('img:visible'), function(img, i) {
        var $img = $(img);
        if ($img.height() >= 144 && $img.width() >= 144)
          return $img.attr('src').trim();
      });

      fbimg = $('meta[property="og:image"]').attr('content');
      if (fbimg)
        images.unshift(fbimg);

      return images;
    }

    return this;
  };

  var Bookmarklet = {

    hide: function() {
      container.fadeOut('fast');
      $('#mamajamasBookmarkletS').remove();
      container.remove();
      window.mamajamas = null;
    },

    show: function(dimensions) {
      if(dimensions) {
        container.css(dimensions);
      }
      if(!iframe.is(':visible')) {
        container.fadeIn('fast');
      }
    },

    // this is accessed by itself
    // when it wants to create a new one
    reset: init,

    populate: function() {
      channel.trigger('populate', Product().data());
    }

  };

  window.addEventListener('message', function(e) {
    var data = e.data;
    // the window is trying to execute
    // some arbitrary custom event
    if(!!data.event) {
      messageListeners[data.event](data.args);
    }
  }, false);

  // listen for calls from iframe
  Utils.addMessageListener('populate-iframe', function() {
    Bookmarklet.populate();
  });

  Utils.addMessageListener('unload-bookmarklet', function() {
    Bookmarklet.hide();
  });

  Utils.addMessageListener('resize-iframe', function(dimensions) {
    Bookmarklet.show(dimensions);
  });

  // creates a way to proxy
  // POST methods to the website directly
  var Channel = function(path) {

    if (iframe) {
      iframe.remove();
      iframe = false;
    }

    iframe = createIframe(path);
    container = createContainer(iframe);

    var c = this,
    cw = iframe[0].contentWindow;

    // provide a way for bookmarklet
    // to trigger custom events in iframe
    this.trigger = function(event, args) {
      cw.postMessage({
        event: event,
        args: args
      }, '*');
    }

    // generate the iframe to proxy
    function createIframe(url) {
      var i = $('<iframe />')
        .attr('src', url)
        .attr('frameborder', 0)
        .attr('name', '')
        .attr('scrolling', 'no')
        .css('width', '546px')
        .css('height', '478px');
      return i;
    }

    function createContainer(i) {
      var d = $('<div />').
        attr('id', 'mamajamasBookmarkletC').
        css('background', 'none rgba(0, 0, 0, 0)').
        css('border', 'none').
        css('cursor', 'pointer').
        css('display', 'none').
        css('outline', '0 none').
        css('overflow', 'hidden').
        css('position', 'fixed').
        css('top', '20px').
        css('right', '20px').
        css('z-index', '999999');

      i.appendTo(d);
      d.appendTo(body);
      return d;
    }

    return this;

  };

  function init() {

    // load jquery
    Utils.loadJquery(function() {

      // when jquery is loaded,
      // create bookmarklet channel
      channel = new Channel(iframeUrl);
    });

    return this;

  };

  init();

  return Bookmarklet;

})();

var Scraper = function() {};
Scraper.prototype.getPrice=function(){var n,a=(new Date).getTime(),b=[],c=/[1-9]/,d=/((?:R?\$|USD|\&pound\;|\&\#163\;|\&\#xa3\;|\u00A3|\&yen\;|\uFFE5|\&\#165\;|\&\#xa5\;|\u00A5|eur|\&\#8364\;|\&\#x20ac\;)\s*\d[0-9\,\.]*)/gi,f=/em/,g=/^(\s|to|\d|\.|\$|\-|,)+$/,h=/club|total|price|sale|now|brightred/i,i=/soldout|currentlyunavailable|outofstock/i,j=/^(h1|h2|h3|b|strong|sale)$/i,k=/^a$/i,l=/original|header|items|under|cart|more|nav|upsell/i,m="",o=-1,p=0,q=function(a){for(var b=new Array("toysrus.com","babiesrus.com","walmart.com"),c=0;c<b.length;c++){var d=new RegExp("^(?:www.)?"+b[c],"i");if(d.test(a))return!1}return!0},r=function(a){for(var b=[],c=a;c.parentNode;)b.push(c.parentNode),c=c.parentNode;return b},s=function(a,b){for(var c=r(a),d=r(b),e=0;e<c.length;e++)for(var f=0;f<d.length;f++)if(c[e]===d[f])return c[e];return void 0},t=function(a){if(document.defaultView&&document.defaultView.getComputedStyle){var b=document.defaultView.getComputedStyle(a,null);return function(a){return b.getPropertyValue(a)}}return function(b){var c={"font-size":"fontSize","font-weight":"fontWeight","text-decoration":"textDecoration"};return a.currentStyle[c[b]?c[b]:b]}},u=function(){return document.createTreeWalker?document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT,function(){return NodeFilter.FILTER_ACCEPT},!1):{q:[],intialized:0,currentNode:void 0,nextNode:function(){for(this.initialized||(this.q.push(document.body),this.initialized=!0);this.q.length;){var a=this.q.pop();if(3==a.nodeType)return this.currentNode=a,!0;if(a.childNodes){if(a.style&&("hidden"==a.style.visibility||"none"==a.style.display))continue;for(var b=new Array(a.childNodes.length),c=0;c<a.childNodes.length;c++)b[c]=a.childNodes[c];b.reverse(),this.q=this.q.concat(b)}}return!1}}},v=function(a){var b=a("font-size")||"",c=f.test(b)?16:1;return b=b.replace(/px|em|pt/,""),b-=0,isNaN(b)?0:b*c},w=function(a){for(var b=a.offsetTop;a.offsetParent;)a=a.offsetParent,b+=a.offsetTop;return b},x=function(a,b){var d=a.node,e=3==d.nodeType?d.parentNode:d,f=a.price,i="";i=3==d.nodeType?d.data:d.innerText||d.textContent;var m=0,n=t(e);n("font-weight"),"bold"==n("font-weight")&&(m+=1),(!e.offsetWidth&&!e.offsetHeight||"hidden"==n("visibility")||"none"==n("display"))&&(m-=100),(d.parentNode.innerText||d.parentNode.textContent).replace(/\s/g,"");var q=i.replace(/\s+/g,"");c.test(f)||(m-=100);var r=q.replace(/price|our/gi,"");r.length<2*f.length+4&&(m+=10),g.test(q)&&(m+=2),-1!=f.indexOf(".")&&(m+=2),m-=Math.abs(w(e)/500),m+=v(n),l.test(i)&&(m-=4),h.test(i)&&m++,d=e;for(var s=0;null!==d&&d!=document.body&&s++<4;){0!==s&&(n=t(d)),"line-through"==n("text-decoration")&&(m-=100);for(var u=0;u<d.childNodes.length;u++)if(3==d.childNodes[u].nodeType){var x=d.childNodes[u];x.data&&(h.test(x.data)&&(m+=1),l.test(x.data)&&(m-=1))}k.test(d.tagName)&&(m-=5),h.test(d.getAttribute("class")||d.getAttribute("className"))&&(m+=1),h.test(d.id)&&(m+=1),j.test(d.tagName)&&(m+=1),l.test(d.tagName)&&(m-=1),l.test(d.id)&&(m-=2),l.test(d.getAttribute("class")||d.getAttribute("className"))&&(m-=2),d=d.parentNode}return m-=i.length/100,m-=b/5};for(walker=u();walker.nextNode()&&b.length<100;){if(0===b.length%100&&(new Date).getTime()-a>1500)return;var y=walker.currentNode,z=y.data.replace(/\s/g,"");d.lastIndex=0;var A=z.match(d);if(0>o&&i.test(z)&&q(document.domain)&&(o=b.length),A){if(A[0].match(/\.$/g)&&walker.nextNode()){var B=walker.currentNode;if(B&&B.data){var C=B.data.replace(/\s/g,"");C&&isNaN(C)&&(C="00"),A[0]+=C}}else A[0].match(/\,$/g)&&(A[0]=A[0].substring(0,A[0].length-1));b.push({node:y,price:A[0]}),z=""}else if(""!==m&&""!==z&&(A=(m+z).match(d))){var D=s(n,y);b.push({node:D,price:A[0]})}n=y,m=z}for(var E=void 0,F=void 0,G=0;G<b.length;G++){var H=x(b[G],G);o>G&&H>0&&(p=1),(void 0===E||H>E)&&(E=H,F=b[G])}return F&&(0>o||p)?F.price:void 0};
