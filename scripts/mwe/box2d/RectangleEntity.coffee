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
  declare 'RectangleEntity', Entity, {
    halfWidth: 1
    halfHeight: 1

    constructor: (args) ->
      declare.safeMixin @, args

    draw: (ctx) ->
      ctx.save()
      ctx.translate @x * SCALE, @y * SCALE
      ctx.rotate @angle
      ctx.translate -(@x) * SCALE, -(@y) * SCALE
      ctx.fillStyle = @color
      ctx.strokeStyle = @strokeStyle
      ctx.fillRect (@x - @halfWidth) * SCALE, (@y - @halfHeight) * SCALE, (@halfWidth * 2) * SCALE, (@halfHeight * 2) * SCALE
      ctx.strokeRect (@x - @halfWidth) * SCALE, (@y - @halfHeight) * SCALE, (@halfWidth * 2) * SCALE, (@halfHeight * 2) * SCALE
      ctx.restore()
      @inherited arguments
  }
