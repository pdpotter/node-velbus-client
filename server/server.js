(function() {
  var Config, app, express;

  Config = require('./config');

  express = require('express');

  app = express();

  app.set('view engine', 'jade');

  app.use(express["static"]('public'));

  app.get('/*', function(req, res) {
    var breadcrumbs, object, path_array, path_part;
    path_array = req.path.split('/');
    object = Config.layout;
    breadcrumbs = [
      {
        url: '/',
        name: 'Home'
      }
    ];
    while (path_array.length > 0) {
      path_part = path_array.shift();
      if (path_part === '') {
        continue;
      }
      object = object[path_part];
      breadcrumbs.push({
        url: breadcrumbs[breadcrumbs.length - 1].url + (breadcrumbs.length > 1 ? '/' : '') + path_part,
        name: object.name
      });
    }
    return res.render('page', {
      object: object,
      breadcrumbs: breadcrumbs
    });
  });

  app.listen(Config.server.port, function() {
    return console.log("Listening on port " + Config.server.port);
  });

}).call(this);
