(function() {
  var Client, modules,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  modules = {
    VMB4RYNO: require('./VMB4RYNO')
  };

  Client = (function() {
    function Client(server) {
      this.send = bind(this.send, this);
      var components;
      this.connection = new WebSocket(server.protocol + '://' + server.host + ':' + server.port);
      this.connection.onerror = function(error) {
        console.log('WebSocket Error ' + error);
      };
      this.connection.onmessage = function(message) {
        var data, element, error, error1;
        data = JSON.parse(message.data);
        element = $(("[data-address='" + data.address + "']") + ("[data-channel='" + data.channel + "']"));
        if ((data.address + '_' + data.channel) in components) {
          try {
            components[data.address + '_' + data.channel].process(data);
          } catch (error1) {
            error = error1;
            console.log(error);
            this.constructor.warn('Unsupported message received.');
          }
        }
      };
      components = {};
      $('.velbus').each((function(_this) {
        return function(index, element) {
          components[($(element).data('address')) + '_' + ($(element).data('channel'))] = new modules[$(element).data('module')]($(element), _this.send);
        };
      })(this));
      return;
    }

    Client.warn = function(message) {
      var icon_class;
      icon_class = 'glyphicon glyphicon-exclamation-sign';
      bootbox.alert({
        message: "<span class='" + icon_class + "' aria-hidden='true' /> " + message
      });
    };

    Client.prototype.send = function(json, counter) {
      if (counter == null) {
        counter = 0;
      }
      if (this.connection.readyState) {
        this.connection.send(json);
      } else {
        if (counter === 10) {
          this.constructor.warn('Cannot connect to server.');
          return;
        }
        setTimeout(((function(_this) {
          return function() {
            _this.send(json, counter + 1);
          };
        })(this)), 100);
      }
    };

    return Client;

  })();

  module.exports = Client;

}).call(this);
