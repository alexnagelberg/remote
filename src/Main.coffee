class Main
  express = require 'express'
  app = express()

  CommandHandler = require './CommandHandler'

  app.use (err, req, res, next) ->
    console.error err.stack
    res.send(500, "something broke");
  
  app.get '/', (req, res) ->
    handler = new CommandHandler null, res
    handler.processRequest().processResponse()

  try
    app.listen 80
  catch err
    console.log 'Shucks howdy. Y\'all need to run as root, space cowboy.'
    console.log err

