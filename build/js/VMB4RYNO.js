(function() {
  var VMB4RYNO;

  VMB4RYNO = (function() {
    function VMB4RYNO(element, send) {
      var checkbox, message;
      this.element = element;
      message = {
        address: this.element.data('address'),
        channel: this.element.data('channel')
      };
      checkbox = $('<input type="checkbox">');
      this.element.append(checkbox);
      checkbox.bootstrapToggle();
      checkbox.change((function(_this) {
        return function() {
          if (checkbox.prop('checked')) {
            _this.element.find('input').data('bs.toggle').off(true);
            message.command = 'switch_relay_on';
          } else {
            _this.element.find('input').data('bs.toggle').on(true);
            message.command = 'switch_relay_off';
          }
          send(JSON.stringify(message));
        };
      })(this));
      message.command = 'relay_status_request';
      send(JSON.stringify(message));
      return;
    }

    VMB4RYNO.prototype.process = function(data) {
      switch (data.message) {
        case 'relay_channel_on':
          return this.element.find('input').data('bs.toggle').on(true);
        case 'relay_channel_off':
          return this.element.find('input').data('bs.toggle').off(true);
        default:
          throw new Error('message_not_supported');
      }
    };

    return VMB4RYNO;

  })();

  module.exports = VMB4RYNO;

}).call(this);
