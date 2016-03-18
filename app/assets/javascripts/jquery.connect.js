// jQuery Connect v0.0.1
// (c) Zulfa Juniadi <http://zulfait.blogspot.com/>
// Usage : var connection = $.connect('#elem1', '#elem2', {options});
// Documentation : http://zulfait.blogspot.com/2013/07/jquery-connect.html
// Source : https://gist.github.com/zulfajuniadi/5928559#file-jquery-connect-js
// Requires : jQuery v1.9+ (Older versions may work, but not tested)
// Suggests : jQuery UI (It works with draggable elements!)
// MIT License

;(function($) {
  $.connect = function(elem1, elem2, options) {
    var defaults = {
      container: '#container',
      leftLabel: '',
      rightLabel: ''
    };
    var parent = this;
    this.elem1 = this.elem1 || $(elem1);
    this.elem2 = this.elem2 || $(elem2);
    if (elem1.length === 0 || elem2.length === 0) {
      throw 'Cannot get instance of Element 1 or Element 2';
    }
    var A = {};
    var B = {};
    var C = {};
    this.options = $.extend(defaults, options || {});
    var makeConnector = function(data) {
      var container = $(parent.options.container);
      var html = $('<div class="connector"><p class="left title"></p><p class="right title"></p></div>');
      if (typeof parent.Connector === 'undefined') {
        parent.Connector = html.appendTo(container);
        parent.Connector.css({
          position: 'absolute',
          width: '100px',
          'border-bottom': '1px solid grey'
        });
        parent.Connector.find('p').css({
          display: 'inline-block',
          'margin-bottom': '-3px'
        });
        parent.Connector.find('.left').css({
          float: 'left',
          padding: '0 10px'
        });
        parent.Connector.find('.right').css({
          float: 'right',
          padding: '0 10px'
        });
        parent.setLabels(parent.options);
      }
      var topOffset = -20;
      if (A.coords.tc[0] > B.coords.tc[0]) {
        parent.Connector.find('.title').css({
          '-webkit-transform': 'rotate(180deg)',
          '-ms-transform': 'rotate(180deg)',
          'transform': 'rotate(180deg)'
        });
      } else {
        parent.Connector.find('.title').css({
          '-webkit-transform': 'rotate(0deg)',
          '-ms-transform': 'rotate(0deg)',
          'transform': 'rotate(0deg)'
        });
      }
      parent.Connector.css({
        top: C.sc[1] + topOffset + 'px',
        left: C.sc[0] + 'px',
        width: C.width + 'px',
        '-webkit-transform': 'rotate(' + C.angleA + 'deg)',
        '-webkit-transform-origin': '0% 100%',
        '-ms-transform': 'rotate(' + C.angleA + 'deg)',
        '-ms-transform-origin': '0% 100%',
        'transform': 'rotate(' + C.angleA + 'deg)',
        'transform-origin': '0% 100%'
      });
    };
    this.setLabels = function(values) {
      var defaults = {
        leftLabel: 'Left',
        rightLabel: 'Right'
      };
      var labels = $.extend(defaults, values);
      $(parent.Connector).find('.title').each(function(idx, elem) {
        var e = $(elem);
        if (e.hasClass('left')) {
          e.html(labels.leftLabel);
        } else {
          e.html(labels.rightLabel);
        }
      });
      return parent;
    };
    var getCoords = function(elem, width, height) {
      function pX(elem) {
        return elem.offset().left;
      }
      function pY(elem) {
        return elem.offset().top+20;
      }
      var px = pX(elem);
      var cen = px + (width / 2);
      var py = pY(elem);
      var mid = py + (height / 2);
      var ret = {
        tl: [px, py],
        tr: [px + width, py],
        tc: [cen, py],
        rm: [px + width, mid],
        bc: [cen, py + height],
        lm: [px, mid]
      };
      return ret;
    };
    this.calculate = function() {
      var elem1 = parent.elem1;
      var elem2 = parent.elem2;
      A.width = elem1.width();
      A.height = elem1.height();
      A.coords = getCoords(elem1, A.width, A.height);
      B.width = elem2.width();
      B.height = elem2.height();
      B.coords = getCoords(elem2, B.width, B.height);
      C.sc = A.coords.rm;
      C.ec = B.coords.lm;
      if ((B.coords.tl[0] - A.coords.tl[0] <= 90) && (B.coords.tl[0] - A.coords.tl[0] >= -90)) {
        if (B.coords.tc[1] <= A.coords.tc[1]) {
          C.sc = A.coords.tc;
          C.ec = B.coords.bc;
        } else {
          C.sc = A.coords.bc;
          C.ec = B.coords.tc;
        }
      } else if (B.coords.tc[0] <= A.coords.tc[0]) {
        C.sc = A.coords.lm;
        C.ec = B.coords.rm;
      }
      C.angleA = Math.atan((C.sc[1] - C.ec[1]) / (C.sc[0] - C.ec[0])) * 180 / Math.PI;
      if (B.coords.tc[0] <= A.coords.tc[0]) {
        C.angleA -= 180;
      }
      C.width = Math.sqrt(Math.pow(C.ec[0] - C.sc[0], 2) + Math.pow(C.ec[1] - C.sc[1], 2));
      makeConnector();
      return parent;
    };
    this.calculate();
    return this;
  };
})(jQuery);
