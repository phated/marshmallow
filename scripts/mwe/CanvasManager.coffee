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

define [ 'dojo/_base/declare', 'dojo/_base/window', 'dojo/dom', 'dojo/dom-construct', 'dojo/domReady!' ], (declare, win, dom, domConstruct) ->
  declare 'CanvasManager', null, {
    canvasId: 'canvas'
    contextType: '2d'
    canvas: null
    context: null
    height: 600
    width: 800
    
    constructor: (args) ->
      declare.safeMixin @, args
      @setCanvas()
      @setHeight()
      @setWidth()
    
    setCanvas: ->
      @canvas = dom.byId @canvasId ? domConstruct.place '<canvas>', win.body()

      return alert 'Sorry, your browser does not support canvas.  I recommend any browser but Internet Explorer' unless @canvas

      @context = @canvas.getContext @contextType

      return alert "Sorry, your browser does not support a #{@contextType} drawing surface on canvas.  I recommend any browser but Internet Explorer" unless @context
        
    setHeight: ->
      # try using game object's dimensions, or set dimensions to canvas if none are specified
      if @height
        @canvas.height = @height
      else
        @height = @canvas.height
        
    setWidth: ->
      # try using game object's dimensions, or set dimensions to canvas if none are specified
      if @width
        @canvas.width = @width
      else
        @width = @canvas.width
        
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
        context.font = "bold #{textPxSize}px sans-serif"

        context.fillText "Loading... #{@resourceManager.getPercentComplete()}%", @width * 0.1, @height * 0.55

        context.strokeRect @width * 0.1, @height * 0.7, @width * 0.8, @height * 0.1
        context.fillRect @width * 0.1, @height * 0.7, @width * 0.8 * @resourceManager.getPercentComplete() / 100, @height * 0.1

        context.lineWidth = 4
  }