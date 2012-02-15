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

define [ 'dojo/_base/declare', 'dojo/_base/window', 'dojo/dom', 'dojo/dom-construct', 'mwe/rAFshim' ], (declare, win, dom, domConstruct) ->
  declare 'GameCore', null, {
    statics: FONT_SIZE: 24
    isRunning : false
    maxStep: 40  # max number of milliseconds between updates. (in case user switches tabs and requestAnimationFrame pauses) 
    resourceManager: null
    inputManager: null
    canvasManager: null

    constructor: (args) ->
      declare.safeMixin @, args

    # Signals the game loop that it's time to quit
    stop: ->
      @isRunning = false

    # Calls init() and gameLoop()
    run: ->
      return if @isRunning
      #@init()
      @loadResources @canvasManager.canvas
      @launchLoop()
      @isRunning = true

    # Should be overidden in the subclasses to create images
    loadResources: (canvas) ->

    # Sets full screen mode and initiates and objects.
    init: ->
      ### TODO: Put this somewhere...
      unless @inputManager
        @inputManager = new InputManager { canvas: @canvas }

      @initInput @inputManager
      ###

    # Should be overidden in the subclasses to map input to actions
    initInput: (inputManager) ->

    # Should be overidden in the subclasses to deal with user input
    handleInput: (inputManager, elapsedTime) ->

    # Runs through the game loop until stop() is called.
    gameLoop: ->
      @currTime = Date.now()
      @elapsedTime = Math.min @currTime - @prevTime, @maxStep
      @prevTime = @currTime

      # it's using a resource manager, but resources haven't finished
      if @resourceManager? and not @resourceManager.resourcesReady()
        @updateLoadingScreen @elapsedTime
        @canvasManager.drawLoadingScreen @canvasManager.context, @resourceManager
      else
        # Need to fix inputManager stuff
        #@handleInput @inputManager, @elapsedTime
        @update @elapsedTime unless @paused
        # draw the screen
        @canvasManager.context.save()
        @canvasManager.draw @canvasManager.context
        @canvasManager.context.restore()

    # Launches the game loop.
    launchLoop: ->
      @currTime = Date.now()
      @elapsedTime = 0
      @prevTime = @currTime

      animloop = =>
        @gameLoop()
        window.requestAnimationFrame animloop, document
      animloop()

    # Updates the state of the game/animation based on the amount of elapsed time that has passed.
    update: (elapsedTime) ->
      # overide this function in your game instance

    # Override this if want to use it update sprites/objects on loading screen
    updateLoadingScreen: (elapsedTime) ->
  }