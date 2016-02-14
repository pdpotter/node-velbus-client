(function() {
  var Config, app, express;

  Config = require('./config');

  express = require('express');

  app = express();

  app.set('view engine', 'jade');

  app.use(express["static"]('public'));

  app.get('/', function(req, res) {
    return res.render('index', {
      rooms: Config.layout
    });
  });

  app.get('/:room', function(req, res) {
    return res.render('room', {
      room: Config.layout[req.params.room]
    });
  });

  app.listen(Config.server.port, function() {
    return console.log("Listening on port " + Config.server.port);
  });

}).call(this);
