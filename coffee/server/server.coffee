# load configuration settings
Config = require './config'

express = require 'express'

app = do express

app.set 'view engine', 'jade'

app.use express.static 'public'

app.get '/*', (req, res) ->
  path_array = req.path.split '/'
  object = Config.layout
  breadcrumbs = [
    {
      url: '/'
      name: 'Home'
    }
  ]
  while path_array.length > 0
    path_part = do path_array.shift
    # Skip if empty path_part (generated by leading or trailing slash)
    if path_part == ''
      continue
    object = object[path_part]
    breadcrumbs.push {
      url: breadcrumbs[breadcrumbs.length - 1].url +
        (if breadcrumbs.length > 1 then '/' else '') +
        path_part
      name: object.name
    }
  res.render 'page', {object: object, breadcrumbs: breadcrumbs}

app.listen Config.server.port, ->
  console.log "Listening on port #{Config.server.port}"
