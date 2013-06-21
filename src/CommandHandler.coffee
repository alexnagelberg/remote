module.exports = class CommandHandler
  constructor: (@request, @response) ->

  processRequest: ->
    @command = @request?.query.command ? "undefined"
    this

  processResponse: ->
    @response.send 200, "command = " + @command if @command?
    this
