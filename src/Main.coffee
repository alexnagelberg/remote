class Main
  express = require 'express'
  app = express()
  lirc_node = require '../lirc_node'
  irsend = new lirc_node.IRSend
  fs = require 'fs'

  static_pages = [
    {
      "file": "index.htm",
      "mime": "text/html"
    }
  ]
  
  CommandHandler = require './CommandHandler'

  app.use (err, req, res, next) ->
    console.error err.stack
    res.send(500, "something broke");

  for page in static_pages
    app.get '/' + page["file"], (req, res) ->
      handler = new CommandHandler req, res
      handler.processRequest (command) ->
        content = fs.readFileSync(page["file"]).toString();
        handler.processResponse content, ->
          console.log 'sent ' + page["file"] 
  
  app.get '/', (req, res) ->
    handler = new CommandHandler req, res
    handler.processRequest (command) -> 
      if command == "menu"
        irsend.send_once 'apple', 'menu', -> 
          handler.processResponse 'OK', ->
            console.log 'menu pressed'
      else
        handler.processResponse command, ->
          console.log 'Sent ' + command + ' back to client.'
        console.log command
  try
    app.listen 80
  catch err
    console.log 'Shucks howdy. Y\'all need to run as root, space cowboy.'
    console.log err

