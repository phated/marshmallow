###

Copyright 2011 Luis Montes

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

###

require [ 'dojo/_base/declare', 'dojo/on', 'dojo/touch', 'dojo/dom-geometry' ], (declare, bind, touch, domGeom) ->
  declare [ bind, touch ], null, {
    keyActions: []
    mouseAction: null
    touchAction: null
    canvas: null
    
    constructor: (args) ->
      declare.safeMixin @, args
      bind document, 'keydown', @keyPressed
      bind document, 'keyup', @keyPressed
      bind @canvas, 'mousedown', @mouseDown
      bind document, 'mouseup', @mouseUp
      bind @canvas, 'mousemove', @mouseMove
      bind document, touch.release, @touchEnd
      bind @canvas, touch.start, @touchStart
      bind @canvas, touch.move, @touchMove
      
    # Maps a GameAction to a specific key. The key codes are defined in java.awt.KeyEvent.
    # If the key already has a GameAction mapped to it, the new GameAction overwrites it.
    mapToKey: (gameAction, keyCode) ->
      unless @keyActions
        @keyActions = []
      @keyActions[keyCode] = gameAction
      
    addKeyAction: (keyCode, initialPressOnly) ->
      ga = new GameAction # GameAction is never required?????????
      if initialPressOnly
        ga.behavior = ga.statics.DETECT_INITIAL_PRESS_ONLY # Can this be replaced by binding to on.once????
      @mapToKey ga, keyCode
      
    setMouseAction: (gameAction) ->
      @mouseAction = gameAction
      
    setTouchAction: (gameAction) ->
      @touchAction = gameAction
      
    mouseUp: (event) ->
    mouseDown: (event) ->
    mouseMove: (event) ->
    touchStart: (event) ->
    touchEnd: (event) ->
    touchMove: (event) ->
    
    getKeyAction: (event) ->
      return @keyActions[event.keyCode] if @keyActions.length
      return null
      
    keyPressed: (event) ->
      gameAction = @getKeyAction event
      gameAction.press() if gameAction? and not gameAction.isPressed()
      
      # make sure the key isn't processed for anything else
	    # TODO
	    # event.consume()
      
    keyReleased: (event) ->
      gameAction = @getKeyAction event
      gameAction.release() if gameAction?
      
      # make sure the key isn't processed for anything else
	    # TODO
	    # event.consume()
      
    keyTyped: (event) ->
      # make sure the key isn't processed for anything else
	    # TODO
	    # event.consume()
      
    getMouseLoc: (event) ->
      coordsM = domGeom.position @canvas
      return { x: Math.round(event.clientX - coordsM.x), y: Math.round(event.clientY - coordsM.y) }
  }