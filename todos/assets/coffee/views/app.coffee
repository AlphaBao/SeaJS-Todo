define (require, exports, module) ->
  $        = require '$'
  _        = require 'underscore'
  Backbone = require 'backbone'
  todos    = require '../collections/todos'
  TodoView = require '../views/todo'

  AppView = Backbone.View.extend

    el: "#todoapp"

    statsTemplate: _.template $("#stats-template").html()

    events:
      "keypress #new-todo": "createOnEnter"
      "click #clear-completed": "clearCompleted"
      "click #toggle-all": "toggleAllComplete"

    initialize: ->
      @allCheckbox = @$el.find("#toggle-all")[0]
      @$input      = @$el.find("#new-todo")
      @$footer     = @$el.find("#footer")
      @$main       = @$el.find("#main")

      @listenTo todos, "add", @addOne
      @listenTo todos, "reset", @addAll
      @listenTo todos, "change:done", @filterOne
      @listenTo todos, "filter", @filterAll
      @listenTo todos, "all", @render

      todos.fetch()

    render: ->
      done = todos.done().length
      remaining = todos.remaining().length

      if todos.length
        @$main.show()
        @$footer.show()

        @$footer.html @statsTemplate
          done: done
          remaining: remaining

        @$el.find("#filter li a")
          .removeClass("selected")
          # .filter("""[href="#/"]""")
          .addClass("selected")
      else
        @$main.hide()
        @$footer.hide()

      @allCheckbox.checked = !remaining

    addOne: (todo) ->
      view = new TodoView(model: todo)
      @$el.find("#todo-list").append view.render().el

    addAll: ->
      @$el.find("#todo-list").html ""
      todos.each @addOne, @

    filterOne: (todo) ->
      todo.trigger "visible"

    filterAll: ->
      todos.each @filterOne, @

    newAttributes: ->
      title: @$input.val().trim()
      order: todos.nextOrder()
      done: false

    createOnEnter: (e) ->
      if e.which is 13 && @$input.val().trim()
        todos.create @newAttributes()
        @$input.val ""

    clearCompleted: ->
      _.invoke todos.done(), "destroy"
      return false

    toggleAllComplete: ->
      done = @allCheckbox.checked

      todos.each (todo) ->
        todo.save done: done

  module.exports = AppView
















