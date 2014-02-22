define (require, exports, module) ->
  $        = require '$'
  _        = require 'underscore'
  Backbone = require 'backbone'

  TodoView = Backbone.View.extend

    tagName: "li"

    template: _.template $("#item-template").html()

    events:
      "click .toggle" : "toggleDone"
      "dblclick label": "edit"
      "click .destroy": "clear"
      "keypress .edit": "updateOnEnter"
      "blur .edit"    : "close"

    initialize: ->
      @listenTo @model, "change", @render
      @listenTo @model, "destroy", @remove
      @listenTo @model, "visible", @toggleVisible

    render: ->
      @$el.html @template(@model.toJSON())
      @$el.toggleClass "done", @model.get("done")
      @toggleVisible()
      @$input = @$el.find ".edit"
      return @

    toggleVisible: ->
      @$el.toggleClass "hidden", @isHidden()

    isHidden: ->
      isDone = @model.get "done"

      return !isDone

    toggleDone: ->
      @model.toggle()

    edit: ->
      @$el.addClass "editing"
      @$input.focus()

    close: ->
      value = @$input.val().trim()

      if value
        @model.save title: value
      else
        @clear()

      @$el.removeClass "editing"

    updateOnEnter: (e) ->
      if e.which is 13
        @close()

    clear: ->
      @model.destroy()

  module.exports = TodoView



