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

require [ 'dojo/_base/declare', 'dojo/dom', './InputManager' ], (declare, dom, InputManager) ->
  declare [ InputManager ], null, {
    statics: {
      FONT_SIZE : 24
    }
    isRunning : false
    canvasId: null
    maxStep: 40  # max number of milliseconds between updates. (in case user switches tabs and requestAnimationFrame pauses)
    contextType: '2d'
    height: 0
    width: 0
    resourceManager: null
    inputManager: null
    loadingForeground: '#00F'
    loadingBackground: '#FFF'

    constructor: (args) ->
      declare.safeMixin @, args

    # Signals the game loop that it's time to quit
    stop: ->
      @isRunning = false

    # Calls init() and gameLoop()
    run: ->
      unless @isRunning
        @init()
        @loadResources @canvas
        @launchLoop()

    # Should be overidden in the subclasses to create images
    loadResources: (canvas) ->

    # Sets full screen mode and initiates and objects.
    init: ->
      unless @canvas
        @canvas = dom.byId @canvasId

      unless @canvas
        return alert 'Sorry, your browser does not support canvas.  I recommend any browser but Internet Explorer'

      unless @context
        @context = @canvas.getContext @contextType

      unless @canvas
        return alert "Sorry, your browser does not support a #{@contextType} drawing surface on canvas.  I recommend any browser but Internet Explorer"

    	# try using game object's dimensions, or set dimensions to canvas if none are specified
      if @height
        @canvas.height = @height
      else
        @height = @canvas.height

      if @width
        @canvas.width = @width
      else
        @width = @canvas.width

      unless @inputManager
        @inputManager = new InputManager { canvas: @canvas }

      @initInput @inputManager

      @isRunning = true
  }
