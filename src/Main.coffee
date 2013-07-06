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
    },
    {
      "file": "loadRemotes.js",
      "mime": "application/x-javascript"
    },
    {
      "file": "remotes.json",
      "mime": "application/json"
    },
    {
      "file": "jquery/jquery-1.10.2.min.js",
      "mime": "application/x-javascript"
    },
    {
      "file": "jquery/jquery.mobile-1.3.1.min.css",
      "mime": "text/css"
    },
    {
      "file": "jquery/jquery.mobile.structure-1.3.1.min.css",
      "mime": "text/css"
    },
    {
      "file": "jquery/jquery.mobile.theme-1.3.1.min.css",
      "mime": "text/css"
    },
    {
      "file": "jquery/jquery.mobile-1.3.1.min.js",
      "mime": "application/x-javascript"
    },
    {
      "file": "jquery/images/ajax-loader.gif",
      "mime": "image/gif"
    },
    {
      "file": "jquery/images/icons-18-black.png",
      "mime": "image/png"
    },
    {
      "file": "jquery/images/icons-18-white.png",
      "mime": "image/png"
    },
    {
      "file": "jquery/images/icons-36-black.png",
      "mime": "image/png"
    },
    {
      "file": "jquery/images/icons-36-white.png",
      "mime": "image/png"
    }
  ]
  
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

