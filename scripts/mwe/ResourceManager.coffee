###

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

###

define [ 'dojo/_base/declare' ], (declare) ->
  declare 'ResourceManager', null, {
    imageCount: 0
    loadedImages: 0
    allLoaded: false
    imageDir: 'images/'
    imgList: []

    constructor: (args) ->
      declare.safeMixin @, args

    # Gets an image.
    loadImage: (filename, width, height) ->
      return image.img for image in @imgList when image.name is filename

      @allLoaded = false
      img = new Image()

      if @imageDir
        filename = @imageDir + filename

      img.src = filename
      @imgList.push { name: filename, img: img }

      return img

    resourcesReady: ->
      if @allLoaded
        return true
      else
        return false for image in @imgList when not image.img.complete
        @allLoaded = true
        return true

    getPercentComplete: ->
      numComplete = 0.0
      numComplete += 1.0 for image in @imgList when image.img.complete
      return 0 if @imgList.length is 0
      return Math.round numComplete / @imgList.length * 100.0

  }
