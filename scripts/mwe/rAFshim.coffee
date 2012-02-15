###
http://paulirish.com/2011/requestanimationframe-for-smart-animating/
http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating

requestAnimationFrame polyfill by Erik Möller
fixes from Paul Irish and Tino Zijdel

Coffeescript and AMD by Blaine Bublitz
###

define [], ->
    lastTime = 0
    vendors = ["ms", "moz", "webkit", "o"]

    # Try browser implementation
    for vendor in vendors
      break if window.requestAnimationFrame
      window.requestAnimationFrame = window["#{vendor}RequestAnimationFrame"]
      window.cancelAnimationFrame = window["#{vendor}CancelAnimationFrame"] or window["#{vendor}CancelRequestAnimationFrame"]

    # Fall back to javascript
    window.requestAnimationFrame ?= (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max 0, 16 - (currTime - lastTime)
      id = setTimeout (->callback(currTime + timeToCall)), timeToCall
      lastTime = currTime + timeToCall
      return id

    window.cancelAnimationFrame ?= clearTimeout