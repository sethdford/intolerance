/*
 *
 * Based on Diego Perini ContentLoaded
 *
 * License: MIT
 *
 */

		
(function (w, f) {

	var	d = window.document,
		D = 'DOMContentLoaded',
		u = w.navigator.userAgent.toLowerCase()

	function init(e) {
		if (!document.loaded) {
			document.loaded = true;
			// pass a fake event if needed
			f((e.type && e.type == D) ? e : {
				type: D,
				target: d,
				eventPhase: 0,
				currentTarget: d,
				timeStamp: +new Date,
				eventType: e.type || e
			});
		}
	}

	// safari < 525.13
	if (/webkit\//.test(u) && v < 525.13) {

		(function () {
			if (/complete|loaded/.test(d.readyState)) {
				init('khtml-poll');
			} else {
				setTimeout(arguments.callee, 10);
			}
		})();

	// internet explorer all versions
	} else if (/msie/.test(u) && !w.opera) {

		d.attachEvent('onreadystatechange',
			function (e) {
				if (d.readyState == 'complete') {
					d.detachEvent('on'+e.type, arguments.callee);
					init(e);
				}
			}
		);
		if (w == top) {
			(function () {
				try {
					d.documentElement.doScroll('left');
				} catch (e) {
					setTimeout(arguments.callee, 10);
					return;
				}
				init('msie-poll');
			})();
		}

	// browsers having native DOMContentLoaded
	} else if (d.addEventListener) {

		d.addEventListener(D,
			function (e) {
				d.removeEventListener(D, arguments.callee, false);
				init(e);
			}, false
		);

	// fallback to last resort for older browsers
	} else {

		// from Simon Willison
		var oldonload = w.onload;
		w.onload = function (e) {
			init(e || w.event);
			if (typeof oldonload == 'function') {
				oldonload(e || w.event);
			}
		};

	}
})(window,function() {
	var divs=document.getElementsByTagName("div");
	
	function disable(e) {
		e = e ? e : window.event;
		
		e.cancelBubble = true;
  		e.cancel = true;
  		e.returnValue = false;
		
  		if(e.stopPropagation) e.stopPropagation();
  		if(e.preventDefault) e.preventDefault();
  		
  		return false;
	}

	
	for (var i=0; i<divs.length; i++) {
		var el = divs[i]
		if (/mouseWheelFix/.test(el.className)) {
			
			if(el.addEventListener) {
				el.addEventListener("DOMMouseScroll", disable, false);  
    			el.addEventListener("mousewheel", disable, false);
  			} else if (el.attachEvent) {
  				el.attachEvent("onmousewheel", disable);
  			}
    		
		}
	}
})
