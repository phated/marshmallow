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

define [ 'dojo/_base/declare', 'mwe/box2d/Entity', 'scripts/thirdparty/Box2d.min.js' ], (declare, Entity) ->
  declare 'PolygonEntity', Entity, {
    points: null

    constructor: (args) ->
      declare.safeMixin @, args
      if not @points
        @points = []

    draw: (ctx) ->
      ctx.save()
      ctx.translate @x * SCALE, @y * SCALE
      ctx.rotate @angle
      ctx.translate -(@x) * SCALE, -(@y) * SCALE
      ctx.fillStyle = @color
      ctx.strokeStyle = @strokeStyle
      ctx.beginPath()
      ctx.moveTo (@x + @points[0].x) * SCALE, (@y + @points[0].y) * SCALE
      ctx.lineTo (point.x + @x) * SCALE, (point.y + @y) * SCALE for point in @points
      ctx.lineTo (@x + @points[0].x) * SCALE, (@y + @points[0].y) * SCALE
      ctx.closePath()
      ctx.fill()
      ctx.stroke()
      ctx.restore()
      @inherited arguments
  }
