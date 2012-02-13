
/*

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
*/

(function() {

  define(['dojo/_base/declare', 'dojo/dom', 'mwe/InputManager'], function(declare, dom, InputManager) {
    return declare('GameCore', null, {
      statics: {
        FONT_SIZE: 24
      },
      isRunning: false,
      canvasId: null,
      maxStep: 40,
      contextType: '2d',
      height: 0,
      width: 0,
      resourceManager: null,
      inputManager: null,
      loadingForeground: '#00F',
      loadingBackground: '#FFF',
      constructor: function(args) {
        return declare.safeMixin(this, args);
      },
      stop: function() {
        return this.isRunning = false;
      },
      run: function() {
        if (!this.isRunning) {
          this.init();
          this.loadResources(this.canvas);
          return this.launchLoop();
        }
      },
      loadResources: function(canvas) {},
      init: function() {
        if (!this.canvas) this.canvas = dom.byId(this.canvasId);
        if (!this.canvas) {
          return alert('Sorry, your browser does not support canvas.  I recommend any browser but Internet Explorer');
        }
        if (!this.context) this.context = this.canvas.getContext(this.contextType);
        if (!this.canvas) {
          return alert("Sorry, your browser does not support a " + this.contextType + " drawing surface on canvas.  I recommend any browser but Internet Explorer");
        }
        if (this.height) {
          this.canvas.height = this.height;
        } else {
          this.height = this.canvas.height;
        }
        if (this.width) {
          this.canvas.width = this.width;
        } else {
          this.width = this.canvas.width;
        }
        if (!this.inputManager) {
          this.inputManager = new InputManager({
            canvas: this.canvas
          });
        }
        this.initInput(this.inputManager);
        return this.isRunning = true;
      },
      initInput: function(inputManager) {},
      handleInput: function(inputManager, elapsedTime) {},
      gameLoop: function() {
        this.currTime = new Date().getTime();
        this.elapsedTime = Math.min(this.currTime - this.prevTime, this.maxStep);
        this.prevTime = this.currTime;
        if ((this.resourceManager != null) && !this.resourceManager.resourcesReady()) {
          this.updateLoadingScreen(this.elapsedTime);
          return this.drawLoadingScreen(this.context);
        } else {
          this.handleInput(this.inputManager, this.elapsedTime);
          if (!this.paused) this.update(this.elapsedTime);
          this.context.save();
          this.draw(this.context);
          return this.context.restore();
        }
      },
      launchLoop: function() {
        var animloop, startTime, thisgame;
        this.elapsedTime = 0;
        startTime = Date.now();
        this.currTime = startTime;
        this.prevTime = startTime;
        window.requestAnimFrame = (function() {
          return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
            return window.setTimeout(callback, 1000 / 60);
          };
        })();
        thisgame = this;
        return (animloop = function() {
          thisgame.gameLoop();
          return requestAnimFrame(animloop, document);
        })();
      },
      loopRunner: function() {
        this.gameLoop();
        return requestAnimFrame(this.loopRunner, this.canvas);
      },
      update: function(elapsedTime) {},
      updateLoadingScreen: function(elapsedTime) {},
      draw: function(context) {
        if (this.contextType === '2d') {
          context.font = '14px sans-serif';
          return context.fillText('This game does not have its own draw function!', 10, 50);
        }
      },
      drawLoadingScreen: function(context) {
        var textPxSize;
        if ((this.resourceManager != null) && this.contextType === '2d') {
          context.fillStyle = this.loadingBackground;
          context.fillRect(0, 0, this.width, this.height);
          context.fillStyle = this.loadingForeground;
          context.strokeStyle = this.loadingForeground;
          textPxSize = Math.floor(this.height / 12);
          context.font = "bold " + textPxSize + "px sans-serif";
          context.fillText("Loading... " + (this.resourceManager.getPercentComplete()) + "%", this.width * 0.1, this.height * 0.55);
          context.strokeRect(this.width * 0.1, this.height * 0.7, this.width * 0.8, this.height * 0.1);
          context.fillRect(this.width * 0.1, this.height * 0.7, this.width * 0.8 * this.resourceManager.getPercentComplete() / 100, this.height * 0.1);
          return context.lineWidth = 4;
        }
      }
    });
  });

}).call(this);
