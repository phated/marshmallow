
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

  define(['dojo/_base/declare', 'mwe/box2d/RectangleEntity'], function(declare, RectangleEntity) {
    return declare('Marshmallow', RectangleEntity, {
      constructor: function(args) {
        return declare.safeMixin(this, args);
      },
      draw: function(ctx) {
        ctx.save();
        ctx.translate(this.x * this.box.scale, this.y * this.box.scale);
        ctx.rotate(this.angle);
        ctx.translate(-this.x * this.box.scale, -this.y * this.box.scale);
        ctx.fillStyle = 'red';
        ctx.drawImage(this.img, (this.x - this.halfWidth) * this.box.scale, (this.y - this.halfHeight) * this.box.scale, (this.halfWidth * 2) * this.box.scale, (this.halfHeight * 2) * this.box.scale);
        return ctx.restore();
      }
    });
  });

}).call(this);
