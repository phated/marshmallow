
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

  define(['dojo/_base/declare'], function(declare) {
    return declare('ResourceManager', null, {
      imageCount: 0,
      loadedImages: 0,
      allLoaded: false,
      imageDir: 'images/',
      imgList: [],
      constructor: function(args) {
        return declare.safeMixin(this, args);
      },
      loadImage: function(filename, width, height) {
        var image, img, _i, _len, _ref;
        _ref = this.imgList;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          if (image.name === filename) return image.img;
        }
        this.allLoaded = false;
        img = new Image();
        if (this.imageDir) filename = this.imageDir + filename;
        img.src = filename;
        this.imgList.push({
          name: filename,
          img: img
        });
        return img;
      },
      resourcesReady: function() {
        var image, _i, _len, _ref;
        if (this.allLoaded) {
          return true;
        } else {
          _ref = this.imgList;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            image = _ref[_i];
            if (!image.img.complete) return false;
          }
          this.allLoaded = true;
          return true;
        }
      },
      getPercentComplete: function() {
        var image, numComplete, _i, _len, _ref;
        numComplete = 0.0;
        _ref = this.imgList;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          if (image.img.complete) numComplete += 1.0;
        }
        if (this.imgList.length === 0) return 0;
        return Math.round(numComplete / this.imgList.length * 100.0);
      }
    });
  });

}).call(this);
