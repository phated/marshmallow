
/*

Copyright 2011 Luis Montes (http://azprogrammer.com)

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

  require(['dojo/_base/declare', 'dojo/dom', 'dojo/dom-geometry', 'mwe/GameCore', 'mwe/ResourceManager', 'mwe/ui/DNDFileController', 'mwe/box2d/Box', 'mwe/box2d/CircleEntity', 'mwe/box2d/RectangleEntity', 'mwe/box2d/PolygonEntity', 'scripts/thirdparty/stats.js', 'scripts/thirdparty/Box2d.min.js'], function(declare, dom, domGeom, GameCore, ResourceManager, DNDFileController, Box, CircleEntity, RectangleEntity, PolygonEntity) {
    var MAX_POLY_SIDES, NULL_CENTER, SCALE, backImg, bodiesState, box, debug, foreImg, geomId, getCollidedSprite, getGfxMouse, intersect, marshImg, maxImpulse, millisToMarsh, millisToMarshPassed, mouseUpHandler, rm, showHidden, solids, stats, worker, world, zones;
    debug = false;
    if ((typeof localStorage !== "undefined" && localStorage !== null) && localStorage.debug === 'y') {
      debug = true;
    }
    SCALE = 30.0;
    NULL_CENTER = {
      x: null,
      y: null
    };
    MAX_POLY_SIDES = 6;
    maxImpulse = 25;
    rm = null;
    backImg = null;
    foreImg = null;
    marshImg = null;
    geomId = 0;
    millisToMarsh = 100;
    millisToMarshPassed = 0;
    showHidden = false;
    stats = new Stats();
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.right = '0px';
    stats.domElement.style.bottom = '0px';
    zones = [];
    world = {};
    worker = null;
    bodiesState = null;
    box = null;
    solids = [
      {
        "id": 42,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 4,
            "y": 19.666666666666668
          }, {
            "x": 4.233333333333333,
            "y": 17.4
          }, {
            "x": 4.466666666666667,
            "y": 16.866666666666667
          }, {
            "x": 5.166666666666667,
            "y": 16.266666666666666
          }, {
            "x": 5.8,
            "y": 16.266666666666666
          }, {
            "x": 6.1,
            "y": 16.366666666666667
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 43,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 4.1,
            "y": 19.666666666666668
          }, {
            "x": 6.333333333333333,
            "y": 16
          }, {
            "x": 18.566666666666666,
            "y": 15.8
          }, {
            "x": 18.77333335876465,
            "y": 19.633333333333333
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 44,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 6.373333358764649,
            "y": 15.973333740234375
          }, {
            "x": 5.973333358764648,
            "y": 14.806667073567708
          }, {
            "x": 5.940000025431315,
            "y": 13.573333740234375
          }, {
            "x": 6.606666692097982,
            "y": 12.740000406901041
          }, {
            "x": 7.340000025431315,
            "y": 12.506667073567709
          }, {
            "x": 7.906666692097982,
            "y": 12.606667073567708
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 45,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 7.940000025431315,
            "y": 12.606667073567708
          }, {
            "x": 8.606666692097981,
            "y": 13.073333740234375
          }, {
            "x": 9.173333358764648,
            "y": 13.740000406901041
          }, {
            "x": 9.140000025431315,
            "y": 14.773333740234374
          }, {
            "x": 8.873333358764649,
            "y": 15.940000406901042
          }, {
            "x": 6.440000025431315,
            "y": 15.973333740234375
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 46,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 10.073333358764648,
            "y": 15.960000610351562
          }, {
            "x": 11.073333358764648,
            "y": 12.926667277018229
          }, {
            "x": 11.473333358764648,
            "y": 12.72666727701823
          }, {
            "x": 13.406666692097982,
            "y": 12.393333943684896
          }, {
            "x": 16.140000025431316,
            "y": 12.660000610351563
          }, {
            "x": 18.27333335876465,
            "y": 13.793333943684896
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 47,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 13.440000025431315,
            "y": 12.353333536783854
          }, {
            "x": 13.940000025431315,
            "y": 11.92000020345052
          }, {
            "x": 15.806666692097982,
            "y": 12.02000020345052
          }, {
            "x": 16.10666669209798,
            "y": 12.620000203450521
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 48,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 13.973333358764648,
            "y": 11.886666870117187
          }, {
            "x": 13.673333358764648,
            "y": 10.486666870117187
          }, {
            "x": 13.673333358764648,
            "y": 9.786666870117188
          }, {
            "x": 13.873333358764649,
            "y": 9.186666870117188
          }, {
            "x": 14.473333358764648,
            "y": 8.653333536783855
          }, {
            "x": 14.840000025431316,
            "y": 8.52000020345052
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 49,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 14.873333358764649,
            "y": 8.553333536783855
          }, {
            "x": 15.306666692097982,
            "y": 8.553333536783855
          }, {
            "x": 15.973333358764648,
            "y": 8.953333536783854
          }, {
            "x": 16.373333358764647,
            "y": 9.52000020345052
          }, {
            "x": 16.07333335876465,
            "y": 11.220000203450521
          }, {
            "x": 15.806666692097982,
            "y": 11.953333536783854
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 50,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 14.006666692097982,
            "y": 11.886666870117187
          }, {
            "x": 14.873333358764649,
            "y": 8.52000020345052
          }, {
            "x": 15.806666692097982,
            "y": 12.02000020345052
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 51,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 10.140000025431315,
            "y": 15.946666971842449
          }, {
            "x": 18.30666669209798,
            "y": 13.780000305175781
          }, {
            "x": 18.540000025431315,
            "y": 15.813333638509114
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon",
        "_inherited": {
          "p": 1
        }
      }, {
        "id": 52,
        "x": 0,
        "y": 0,
        "points": [
          {
            "x": 8.9,
            "y": 15.958333333333334
          }, {
            "x": 9.166666666666666,
            "y": 14.891666666666667
          }, {
            "x": 9.633333333333333,
            "y": 15.025
          }, {
            "x": 9.933333333333334,
            "y": 15.391666666666667
          }, {
            "x": 10.1,
            "y": 15.725
          }, {
            "x": 10.066666666666666,
            "y": 15.958333333333334
          }
        ],
        "staticBody": true,
        "hidden": true,
        "type": "Polygon"
      }
    ];
    declare('Marshmallow', RectangleEntity, {
      constructor: function(args) {
        return declare.safeMixin(this, args);
      },
      draw: function(ctx) {
        ctx.save();
        ctx.translate(this.x * SCALE, this.y * SCALE);
        ctx.rotate(this.angle);
        ctx.translate(-this.x * SCALE, -this.y * SCALE);
        ctx.fillStyle = 'red';
        ctx.drawImage(this.img, (this.x - this.halfWidth) * SCALE, (this.y - this.halfHeight) * SCALE, (this.halfWidth * 2) * SCALE, (this.halfHeight * 2) * SCALE);
        return ctx.restore();
      }
    });
    getGfxMouse = function(event) {
      var coordsM;
      coordsM = domGeom.position(dom.byId('canvas'));
      return {
        x: (event.clientX - coordsM.x) / SCALE,
        y: (event.clientY - coordsM.y) / SCALE
      };
    };
    intersect = function(s1, s2, radiiSquared) {
      var distance_squared;
      distance_squared = Math.pow(s1.x - s2.x, 2) + Math.pow(s1.y - s2.y, 2);
      return distance_squared < radiiSquared;
    };
    getCollidedSprite = function(mouse) {
      var sprite, spriteId;
      for (spriteId in world) {
        sprite = world[spriteId];
        if (intersect(mouse, sprite, 0.5)) return sprite;
      }
      return null;
    };
    mouseUpHandler = function(event) {
      var mouseDownPt, obj, pt;
      mouseDownPt = null;
      pt = getGfxMouse(event);
      console.log("mouse: " + pt);
      obj = getCollidedSprite(pt);
      console.log("sprite: " + obj);
      if (obj) {
        console.log("obj: " + obj);
        return box.applyImpulse(obj.id, Math.random() * 360, 100);
      }
    };
    return require(['dojo/dom-construct', 'dojo/_base/window', 'dojo/on', 'dojo/touch', 'dojo/domReady!'], function(domConstruct, window, bind, touch) {
      var addBodies, game, shape, _i, _len;
      if (debug) domConstruct.place(stats.domElement, window.body(), 'last');
      rm = new ResourceManager();
      backImg = rm.loadImage('cannon.png');
      foreImg = rm.loadImage('foreground.png');
      marshImg = rm.loadImage('marsh32.png');
      bind(document, 'mouseup', mouseUpHandler);
      bind(document, touch.release, function(event) {
        return mouseUpHandler(event.changedTouches[0]);
      });
      bind(document, 'selectstart', function(event) {
        event.preventDefault();
        return false;
      });
      game = new GameCore({
        canvasId: 'canvas',
        resourceManager: rm,
        update: function(elapsedTime) {
          var entity, id, marsh;
          try {
            box.update();
            bodiesState = box.getState();
            for (id in bodiesState) {
              entity = world[id];
              if (entity) {
                try {
                  if (entity.y > 100) {
                    box.removeBody(id);
                    delete world[id];
                  } else {
                    entity.update(bodiesState[id]);
                  }
                } catch (eu) {
                  console.log(entity, bodiesState[id], eu);
                }
              }
            }
            if (debug) stats.update();
            millisToMarshPassed += elapsedTime;
            if (millisToMarshPassed > millisToMarsh) {
              millisToMarshPassed = 0;
              geomId++;
              marsh = new Marshmallow({
                id: geomId,
                x: Math.random() * 16 + 3,
                y: Math.random() * 10 - 10,
                halfHeight: (32 / SCALE) / 2,
                halfWidth: (32 / SCALE) / 2,
                img: marshImg,
                staticBody: false,
                restitution: 0.5
              });
              box.addBody(marsh);
              return world[geomId] = marsh;
            }
          } catch (updateE) {
            return console.log("error in update: " + updateE);
          }
        },
        draw: function(ctx) {
          var entity, id;
          ctx.drawImage(backImg, 0, 0, this.width, backImg.height);
          for (id in world) {
            entity = world[id];
            if (!entity.hidden || showHidden) entity.draw(ctx);
          }
          return ctx.drawImage(foreImg, 0, 0, this.width, foreImg.height);
        }
      });
      box = new Box({
        intervalRate: 60,
        adaptive: false,
        width: game.width,
        height: game.height,
        scale: SCALE,
        gravityY: 9.8
      });
      addBodies = function(shape) {
        var b2dshape;
        console.log(shape.type);
        geomId++;
        if (shape.type === 'Polygon') {
          b2dshape = new PolygonEntity(shape);
          b2dshape.id = geomId;
          box.addBody(b2dshape);
          return world[geomId] = b2dshape;
        }
      };
      for (_i = 0, _len = solids.length; _i < _len; _i++) {
        shape = solids[_i];
        addBodies(shape);
      }
      return game.run();
    });
  });

}).call(this);
