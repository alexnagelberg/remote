lirc_node = require('../lirc_node')

module.exports = class CommandHandler
  constructor: (@request, @response) ->

  processRequest: (done) ->
    command = @request?.query.command ? "undefined"
    done command
    this

  processResponse: (body, done) ->
    @response.send 200, body
    done()
    this
