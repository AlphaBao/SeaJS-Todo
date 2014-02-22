define (require, exports, module) ->
  Backbone = require 'backbone'

  Todo = Backbone.Model.extend
    defaluts:
      title: ""
      done: false

    toggle: ->
      @save done: !@get("done")
