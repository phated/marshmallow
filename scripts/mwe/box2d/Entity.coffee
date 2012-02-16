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

define [ 'dojo/_base/declare', 'dojo/_base/lang', 'scripts/thirdparty/Box2d.min.js' ], (declare, lang) ->
  declare 'Entity', null, {
    id: 0
    x: 0
    y: 0
    angle: 0
    center: 0
    restitution: 0.3
    density: 1.0
    friction: 0.9
    linearDamping: 0
    angularDamping: 0
    staticBody: false
    color: 'rgba(128,128,128,0.5)'
    strokeStyle: '#000000'
    hidden: false
    box: null

    constructor: (args) ->
      declare.safeMixin @, args

    update: (state) ->
      if state
        lang.mixin @, state

    draw: (ctx) ->
      # Black circle in entity's location
      ctx.fillStyle = @strokeStyle
      ctx.beginPath()
      ctx.arc @x * SCALE, @y * SCALE, 4, 0, Math.PI * 2, true
      ctx.closePath()
      ctx.fill()

      # Yellow circle in entity's geometric center
      ctx.fillStyle = 'yellow'
      ctx.beginPath()
      ctx.arc @center.x * SCALE, @center.y * SCALE, 2, 0, Math.PI * 2, true
      ctx.closePath()
      ctx.fill()

    build: (def) ->
      return new CircleEntity def if def.radius
      return new PolygonEntity def if def.points
      return new ImageEntity def if def.img
      return new RectangleEntity def
  }