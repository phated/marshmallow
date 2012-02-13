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

define [ 'dojo/_base/declare', 'dojo/dom', 'mwe/InputManager' ], (declare, dom, InputManager) ->
  declare 'GameCore', null, {
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

    # Should be overidden in the subclasses to map input to actions
    initInput: (inputManager) ->

    # Should be overidden in the subclasses to deal with user input
    handleInput: (inputManager, elapsedTime) ->

    # Runs through the game loop until stop() is called.
    gameLoop: ->
      @currTime = new Date().getTime()
      @elapsedTime = Math.min @currTime - @prevTime, @maxStep
      @prevTime = @currTime

      # it's using a resource manager, but resources haven't finished
      if @resourceManager? and not @resourceManager.resourcesReady()
        @updateLoadingScreen @elapsedTime
        @drawLoadingScreen @context
      else
        @handleInput @inputManager, @elapsedTime
        unless @paused
          # update
          @update @elapsedTime
        # draw the screen
        @context.save()
        @draw @context
        @context.restore()

      # requestAnimFrame @gameLoop(), @canvas

    # Launches the game loop.
    launchLoop: ->
      @elapsedTime = 0
      startTime = Date.now()
      @currTime = startTime
      @prevTime = startTime

      # shim layer with setTimeout fallback
      window.requestAnimFrame = (->
        window.requestAnimationFrame or
        window.webkitRequestAnimationFrame or
        window.mozRequestAnimationFrame or
        window.oRequestAnimationFrame or
        window.msRequestAnimationFrame or
        (callback, element) ->
          window.setTimeout callback, 1000/60
      )()

      # usage:
      # instead of setInterval render, 16

      thisgame = @

      (animloop = ->
        thisgame.gameLoop()
        requestAnimFrame animloop, document
      )()

      # requestAnimFrame(@gameLoop(), @canvas);
  	  # @gameLoop();

    loopRunner: ->
      @gameLoop()
      requestAnimFrame @loopRunner, @canvas

    # Updates the state of the game/animation based on the amount of elapsed time that has passed.
    update: (elapsedTime) ->
      # overide this function in your game instance

    # Override this if want to use it update sprites/objects on loading screen
    updateLoadingScreen: (elapsedTime) ->

    # Draws to the screen. Subclasses or instances must override this method to paint items to the screen.
    draw: (context) ->
      if @contextType is '2d'
        context.font = '14px sans-serif'
        context.fillText 'This game does not have its own draw function!', 10, 50

    drawLoadingScreen: (context) ->
      if @resourceManager? and @contextType is '2d'
        context.fillStyle = @loadingBackground
        context.fillRect 0, 0, @width, @height
        context.fillStyle = @loadingForeground
        context.strokeStyle = @loadingForeground

        textPxSize = Math.floor @height/12
        # loadingText =
      	# textWidth = ctx.measureText(s.text).width

        context.font = "bold #{textPxSize}px sans-serif"

        context.fillText "Loading... #{@resourceManager.getPercentComplete()}%", @width * 0.1, @height * 0.55

        context.strokeRect @width * 0.1, @height * 0.7, @width * 0.8, @height * 0.1
        context.fillRect @width * 0.1, @height * 0.7, @width * 0.8 * @resourceManager.getPercentComplete() / 100, @height * 0.1

        context.lineWidth = 4

  }
