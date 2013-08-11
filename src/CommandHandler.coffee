lirc_node = require('../lirc_node')

module.exports = class CommandHandler
  constructor: (@request, @response) ->

  processRequest: (done, args) ->
    key = @request?.query.key ? "undefined"
    remote = @request?.query.remote ? "undefined"
    done remote, key, args

  processMacro: (done) ->
    command = @request?.query.command ? "undefined"
    done command

  processResponse: (body, type, done) ->
    @response.setHeader 'Content-Type', type
    @response.send 200, body
    done()
