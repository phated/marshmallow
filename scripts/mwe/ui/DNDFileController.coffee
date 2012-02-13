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

define [ 'dojo/_base/declare', 'dojo/dom', 'dojo/on', 'dojo/dom-style' ], (declare, dom, bind, domStyle) ->
  declare 'DNDFileController', null, {
    node: null # the DOM element
    borderStyle: null
    borderDropStyle: '3px dashed red'

    constructor: (args) ->
      declare.safeMixin @, args
      @node = dom.byId @id unless @node?
      bind @node, 'dragenter', @dragenter
      bind @node, 'dragover', @dragover
      bind @node, 'dragleave', @dragleave
      bind @node, 'drop', @preDrop
      @borderStyle = domStyle.get @node, 'border'

    dragenter: (event) ->
      event.stopPropagation()
      event.preventDefault()
      domStyle.set @node, 'border', @borderDropStyle

    dragover: (event) ->
      event.stopPropagation()
      event.preventDefault()

    dragleave: (event) ->
      event.stopPropagation()
      event.preventDefault()
      domStyle.set @node, 'border', @borderStyle

    preDrop: (event) ->
      domStyle.set @node, 'border', @borderStyle
      event.stopPropagation()
      event.preventDefault()
      @drop event

    drop: (event) ->
      try
        files = event.dataTransfer.files
        for file in files
          reader = new FileReader()
          console.log "File: #{file}"
          reader.onerror = (evt) ->
            console.log "Error code: #{evt.target.error.code}"
          reader.onload = ((aFile) ->
            return (evt) ->
              console.log "base64 length: #{evt.target.result.length}" if evt.target.readyState is FileReader.DONE
          )(file)
          reader.readAsDataURL file
        return false
      catch dropE
        console.log "DnD Error: #{dropE}"

  }
