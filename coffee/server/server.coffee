# load configuration settings
Config = require './config'

express = require 'express'

app = do express

app.set 'view engine', 'jade'

app.use express.static 'public'

app.get '/', (req, res) ->
  res.render 'index', {rooms: Config.layout}

app.get '/:room', (req, res) ->
  res.render 'room', {room: Config.layout[req.params.room]}

app.listen Config.server.port, ->
  console.log "Listening on port #{Config.server.port}"
