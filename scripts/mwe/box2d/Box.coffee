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

define [ 'dojo/_base/declare', 'scripts/thirdparty/Box2d.min.js' ], (declare) ->
  b2Vec2 = Box2D.Common.Math.b2Vec2
  b2BodyDef = Box2D.Dynamics.b2BodyDef
  b2Body = Box2D.Dynamics.b2Body
  b2FixtureDef = Box2D.Dynamics.b2FixtureDef
  b2Fixture = Box2D.Dynamics.b2Fixture
  b2World = Box2D.Dynamics.b2World
  b2MassData = Box2D.Collision.Shapes.b2MassData
  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
  b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
  b2DebugDraw = Box2D.Dynamics.b2DebugDraw
  declare 'Box', null, {
    intervalRate: 60
    adaptive: false
    width: 640
    height: 480
    scale: 30
    bodiesMap: null
    fixturesMap: null
    world: null
    gravityX: 0
    gravityY: 10
    allowSleep: true

    constructor: (args) ->
      declare.safeMixin @, args
      @intervalRate = parseInt args.intervalRate if args.intervaleRate
      @bodiesMap = [] unless @bodiesMap?
      @fixturesMap = [] unless @fixturesMap?
      @world = new b2World new b2Vec2(@gravityX, @gravityY), @allowSleep

    update: ->
      start = Date.now()
      stepRate = (if (@adaptive) then (now - @lastTimestamp) / 1000 else (1 / @intervalRate))
      @world.Step stepRate, 10, 10
      @world.ClearForces()
      return Date.now() - start

    getState: ->
      state = {}
      b = @world.GetBodyList()

      while b
        if b.IsActive() and typeof b.GetUserData() isnt "undefined" and b.GetUserData()?
          state[b.GetUserData()] =
            x: b.GetPosition().x
            y: b.GetPosition().y
            angle: b.GetAngle()
            center:
              x: b.GetWorldCenter().x
              y: b.GetWorldCenter().y
        b = b.m_next
      return state

    setBodies: (bodyEntities) ->
      console.log 'bodies', bodyEntities
      @addBody entity for id, entity of bodyEntities
      @ready = true

    addBody: (entity) ->
      bodyDef = new b2BodyDef()
      fixDef = new b2FixtureDef()
      fixDef.restitution = entity.restitution
      fixDef.density = entity.density
      fixDef.friction = entity.friction

      if entity.staticBody
        bodyDef.type = b2Body.b2_staticBody
      else
        bodyDef.type = b2Body.b2_dynamicBody

      if entity.radius
        fixDef.shape = new b2CircleShape entity.radius
      else if entity.points
        points = []
        for point, i in entity.points
          vec = new b2Vec2()
          vec.Set point.x, point.y
          points[i] = vec
        fixDef.shape = new b2PolygonShape
        fixDef.shape.SetAsArray points, points.length
      else
        fixDef.shape = new b2PolygonShape
        fixDef.shape.SetAsBox entity.halfWidth, entity.halfHeight
      bodyDef.position.x = entity.x
      bodyDef.position.y = entity.y
      bodyDef.userData = entity.id
      bodyDef.linearDamping = entity.linearDamping
      bodyDef.angularDamping = entity.angularDamping
      @bodiesMap[entity.id] = @world.CreateBody bodyDef
      @fixturesMap[entity.id] = @bodiesMap[entity.id].CreateFixture fixDef

    applyImpulse: (bodyId, degrees, power) ->
      body = @bodiesMap[bodyId]
      body.ApplyImpulse new b2Vec2(Math.cos(degrees * (Math.PI / 180)) * power, Math.sin(degrees * (Math.PI / 180)) * power), body.GetWorldCenter() if body

    removeBody: (id) ->
      if @bodiesMap[id]
        @bodiesMap[id].DestroyFixture @fixturesMap[id]
        @world.DestroyBody @bodiesMap[id]
        delete @fixturesMap[id]
        delete @bodiesMap[id]
  }
