class Main
  express = require 'express'
  app = express()
  lirc_node = require '../lirc_node'
  irsend = new lirc_node.IRSend
  fs = require 'fs'
  static_pages = require '../pages.json'
  macros = require '../macros.json'
  
  CommandHandler = require './CommandHandler'

  app.use (err, req, res, next) ->
    console.error err.stack
    res.send(500, "something broke");

  for page in static_pages
    do (page) ->
      app.use '/' + page["file"], (req, res) ->
        handler = new CommandHandler req, res
        handler.processRequest ->
          content = fs.readFileSync("public/" + page["file"].toString());
          handler.processResponse content, page["mime"], ->
            console.log 'sent ' + page["file"]

  app.get '/', (req, res) ->
    handler = new CommandHandler req, res
    handler.processRequest ->
      content = fs.readFileSync "public/index.htm"
      handler.processResponse content, "text/html", ->
        console.log 'sent index.htm'

  app.get '/macro', (req, res) ->
    handler = new CommandHandler req, res
    handler.processMacro (command) ->
      if macros[command]
        for press in macros[command]
          do (press) ->
            setTimeout ->
              irsend.send_once press.remote, press.keys
            , press.delay
        handler.processResponse "ok", "text/html", ->
          console.log "sent macro " + command
      else
        handler.processResponse "no", "text/html"

  app.get '/send_once', (req, res) ->
    handler = new CommandHandler req, res
    handler.processRequest (remote, key) -> 
      irsend.send_once remote, key, -> 
        handler.processResponse 'OK', 'text/html', ->
          console.log key + ' pressed'

  app.get '/pulse', (req, res) ->
    handler = new CommandHandler req, res
    handler.processRequest (remote, key) ->
      irsend.send_start remote, key, ->
        console.log key + ' started'
      setTimeout ->
        irsend.send_stop remote, key, ->
          handler.processResponse 'OK', 'text/html', ->
            console.log key + ' stopped'
      , 1000

  try
    app.listen 80
  catch err
    console.log 'Shucks howdy. Y\'all need to run as root, space cowboy.'
    console.log err

