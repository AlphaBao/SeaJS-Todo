define (require, exports, module) ->
  $        = require '$'
  _        = require 'underscore'
  Backbone = require 'backbone'
  Todo     = require '../models/todo'

  require 'backboneLocalStorage'

  Todos = Backbone.Collection.extend
    model: Todo

    localStorage: new Backbone.LocalStorage("todos-backbone")

    done: ->
      @where done: true

    remaining: ->
      @where done: false

    nextOrder: ->
      if @length
        this.last().get("order") + 1
      else
        1

    comparator: (todo) ->
      todo.get "order"

  module.exports = new Todos()
