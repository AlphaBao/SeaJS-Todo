define (require, exports, module) ->
  Backbone = require 'backbone'
  app      = require './views/app'

  new app()

