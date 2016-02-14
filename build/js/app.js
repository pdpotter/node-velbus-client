(function() {
  var Client;

  Client = require('./client');

  $(document).ready(function() {
    new Client(node_velbus_client_config.server);
  });

}).call(this);
