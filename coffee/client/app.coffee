Client = require ('./client')

$(document).ready ->
  new Client node_velbus_client_config.server
  return
