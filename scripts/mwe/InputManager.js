
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
  var _this = this;

  define(['dojo/_base/declare', 'dojo/on', 'dojo/touch', 'dojo/dom-geometry'], function(declare, bind, touch, domGeom) {
    return declare('InputManager', null, {
      keyActions: [],
      mouseAction: null,
      touchAction: null,
      canvas: null,
      constructor: function(args) {
        declare.safeMixin(this, args);
        bind(document, 'keydown', this.keyPressed);
        bind(document, 'keyup', this.keyPressed);
        bind(this.canvas, 'mousedown', this.mouseDown);
        bind(document, 'mouseup', this.mouseUp);
        bind(this.canvas, 'mousemove', this.mouseMove);
        bind(document, touch.release, this.touchEnd);
        bind(this.canvas, touch.press, this.touchStart);
        return bind(this.canvas, touch.move, this.touchMove);
      },
      mapToKey: function(gameAction, keyCode) {
        if (!this.keyActions) this.keyActions = [];
        return this.keyActions[keyCode] = gameAction;
      },
      addKeyAction: function(keyCode, initialPressOnly) {
        var ga;
        ga = new GameAction;
        if (initialPressOnly) ga.behavior = ga.statics.DETECT_INITIAL_PRESS_ONLY;
        return this.mapToKey(ga, keyCode);
      },
      setMouseAction: function(gameAction) {
        return this.mouseAction = gameAction;
      },
      setTouchAction: function(gameAction) {
        return this.touchAction = gameAction;
      },
      mouseUp: function(event) {},
      mouseDown: function(event) {},
      mouseMove: function(event) {},
      touchStart: function(event) {},
      touchEnd: function(event) {},
      touchMove: function(event) {},
      getKeyAction: function(event) {
        if (this.keyActions.length) return this.keyActions[event.keyCode];
        return null;
      },
      keyPressed: function(event, test) {},
      keyReleased: function(event) {
        var gameAction;
        gameAction = this.getKeyAction(event);
        if (gameAction != null) return gameAction.release();
      },
      keyTyped: function(event) {},
      getMouseLoc: function(event) {
        var coordsM;
        coordsM = domGeom.position(this.canvas);
        return {
          x: Math.round(event.clientX - coordsM.x),
          y: Math.round(event.clientY - coordsM.y)
        };
      }
    });
  });

}).call(this);
