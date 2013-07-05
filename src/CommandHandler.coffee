lirc_node = require('../lirc_node')

module.exports = class CommandHandler
  constructor: (@request, @response) ->

  processRequest: (done, args) ->
    command = @request?.query.command ? "undefined"
    done command, args

  processResponse: (body, type, done) ->
    @response.setHeader 'Content-Type', type
    @response.send 200, body
    done()
