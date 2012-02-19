###

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

###

require [ 'dojo/dom', 'dojo/dom-geometry', 'mwe/GameCore', 'mwe/ResourceManager', 'mwe/CanvasManager', 'mwe/InputManager', 'mwe/box2d/Box', 'mwe/box2d/CircleEntity', 'mwe/box2d/RectangleEntity', 'mwe/box2d/PolygonEntity', 'Marshmallow', 'thirdparty/stats', 'scripts/thirdparty/Box2d.min.js' ], (dom, domGeom, GameCore, ResourceManager, CanvasManager, InputManager, Box, CircleEntity, RectangleEntity, PolygonEntity, Marshmallow, Stats) ->
  debug = if localStorage? and localStorage.debug is 'y' then true else false

  SCALE = 30.0

  geomId = 11
  millisToMarsh = 100
  millisToMarshPassed = 0

  showHidden = false

  stats = new Stats()
  stats.getDomElement().style.position = 'absolute'
  stats.getDomElement().style.right = '0px'
  stats.getDomElement().style.bottom = '0px'

  world = {}

  solids = [{"id":0,"x":0,"y":0,"points":[{"x":4,"y":19.666666666666668},{"x":4.233333333333333,"y":17.4},{"x":4.466666666666667,"y":16.866666666666667},{"x":5.166666666666667,"y":16.266666666666666},{"x":5.8,"y":16.266666666666666},{"x":6.1,"y":16.366666666666667}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":1,"x":0,"y":0,"points":[{"x":4.1,"y":19.666666666666668},{"x":6.333333333333333,"y":16},{"x":18.566666666666666,"y":15.8},{"x":18.77333335876465,"y":19.633333333333333}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":2,"x":0,"y":0,"points":[{"x":6.373333358764649,"y":15.973333740234375},{"x":5.973333358764648,"y":14.806667073567708},{"x":5.940000025431315,"y":13.573333740234375},{"x":6.606666692097982,"y":12.740000406901041},{"x":7.340000025431315,"y":12.506667073567709},{"x":7.906666692097982,"y":12.606667073567708}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":3,"x":0,"y":0,"points":[{"x":7.940000025431315,"y":12.606667073567708},{"x":8.606666692097981,"y":13.073333740234375},{"x":9.173333358764648,"y":13.740000406901041},{"x":9.140000025431315,"y":14.773333740234374},{"x":8.873333358764649,"y":15.940000406901042},{"x":6.440000025431315,"y":15.973333740234375}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":4,"x":0,"y":0,"points":[{"x":10.073333358764648,"y":15.960000610351562},{"x":11.073333358764648,"y":12.926667277018229},{"x":11.473333358764648,"y":12.72666727701823},{"x":13.406666692097982,"y":12.393333943684896},{"x":16.140000025431316,"y":12.660000610351563},{"x":18.27333335876465,"y":13.793333943684896}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":5,"x":0,"y":0,"points":[{"x":13.440000025431315,"y":12.353333536783854},{"x":13.940000025431315,"y":11.92000020345052},{"x":15.806666692097982,"y":12.02000020345052},{"x":16.10666669209798,"y":12.620000203450521}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":6,"x":0,"y":0,"points":[{"x":13.973333358764648,"y":11.886666870117187},{"x":13.673333358764648,"y":10.486666870117187},{"x":13.673333358764648,"y":9.786666870117188},{"x":13.873333358764649,"y":9.186666870117188},{"x":14.473333358764648,"y":8.653333536783855},{"x":14.840000025431316,"y":8.52000020345052}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":7,"x":0,"y":0,"points":[{"x":14.873333358764649,"y":8.553333536783855},{"x":15.306666692097982,"y":8.553333536783855},{"x":15.973333358764648,"y":8.953333536783854},{"x":16.373333358764647,"y":9.52000020345052},{"x":16.07333335876465,"y":11.220000203450521},{"x":15.806666692097982,"y":11.953333536783854}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":8,"x":0,"y":0,"points":[{"x":14.006666692097982,"y":11.886666870117187},{"x":14.873333358764649,"y":8.52000020345052},{"x":15.806666692097982,"y":12.02000020345052}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":9,"x":0,"y":0,"points":[{"x":10.140000025431315,"y":15.946666971842449},{"x":18.30666669209798,"y":13.780000305175781},{"x":18.540000025431315,"y":15.813333638509114}],"staticBody":true,"hidden":true,"type":"Polygon","_inherited":{"p":1}},{"id":10,"x":0,"y":0,"points":[{"x":8.9,"y":15.958333333333334},{"x":9.166666666666666,"y":14.891666666666667},{"x":9.633333333333333,"y":15.025},{"x":9.933333333333334,"y":15.391666666666667},{"x":10.1,"y":15.725},{"x":10.066666666666666,"y":15.958333333333334}],"staticBody":true,"hidden":true,"type":"Polygon"}]

  # Resource Manager
  rm = new ResourceManager imageDir: 'images/'
  images = rm.loadFiles backImg: 'cannon.png', foreImg: 'foreground.png', marshImg: 'marsh32.png'

  # Canvas Manager - Notice how this isn't inside a dojo/domReady! - It is because CanvasManager requires it before executing
  cm = new CanvasManager {
    canvasId: 'canvas'
    height: 590
    width: 620
    draw: (ctx) ->
      ctx.drawImage images.backImg, 0, 0, @width, images.backImg.height
      entity.draw ctx for id, entity of world when not entity.hidden or showHidden
      ctx.drawImage images.foreImg, 0, 0, @width, images.foreImg.height
  }

  # Box Wrapper for Box2d
  box = new Box {
    intervalRate: 60
    adaptive: false
    width: cm.width
    height: cm.height
    scale: SCALE
    gravityY: 9.8
  }
  box.setBodies solids

  im = new InputManager {
    box: box
    canvasManager: cm
    mouseUp: (event) ->
      obj = getCollidedSprite @getMouseLoc event
      @box.applyImpulse obj.id, Math.random() * 360, 100 if obj
    touchEnd: (event) ->
      @mouseUp event.changedTouches[0]
    selectstart: (event) ->
      event.preventDefault()
      return false
  }
  im.bindMouse()
  im.bindTouch()
  im.bind document, 'selectstart'

  game = new GameCore {
    canvasManager: cm
    resourceManager: rm
    update: (elapsedTime) ->
      try
        box.update()
        bodiesState = box.getState()

        for id of bodiesState
          entity = world[id]
          if entity
            try
              if entity.y > 100
                box.removeBody id
                delete world[id]
              else
                entity.update bodiesState[id]
            catch eu
              console.log entity, bodiesState[id], eu

        stats.update() if debug

        millisToMarshPassed += elapsedTime
        if millisToMarshPassed > millisToMarsh
          millisToMarshPassed = 0
          geomId++
          marsh = new Marshmallow {
            id: geomId
            x: Math.random() * 16 + 3
            y: Math.random() * 10 - 10
            halfHeight: (32 / SCALE) / 2
            halfWidth: (32 / SCALE) / 2
            img: images.marshImg
            staticBody: false
            restitution: 0.5
            box: box
          }
          box.addBody marsh
          world[geomId] = marsh
      catch updateE
        # just in case of any unexplainable box2d errors
        console.log 'error in update', updateE
  }

  intersect = (s1, s2, radiiSquared) ->
    distance_squared = Math.pow(s1.x - s2.x,2) + Math.pow(s1.y - s2.y,2)
    return distance_squared < radiiSquared # true if intersect

  getCollidedSprite = (mouse) ->
    return sprite for spriteId, sprite of world when intersect mouse, sprite, 0.5
    return null

  require [ 'dojo/dom-construct', 'dojo/_base/window', 'dojo/domReady!' ], (domConstruct, win) ->
    domConstruct.place stats.getDomElement(), win.body(), 'last' if debug
    game.run()
