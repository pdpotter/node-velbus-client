(function() {
  exports.server = {
    port: 8080
  };

  exports.layout = {
    'living-room': {
      name: 'Living room',
      components: [
        {
          name: 'Lights',
          address: '01',
          channel: '1',
          module: 'VMB4RYNO'
        }, {
          name: 'Fan',
          address: '01',
          channel: '2',
          module: 'VMB4RYNO'
        }
      ]
    },
    kitchen: {
      name: 'Kitchen',
      components: [
        {
          name: 'Lights',
          address: '01',
          channel: '3',
          module: 'VMB4RYNO'
        }, {
          name: 'Fan',
          address: '01',
          channel: '4',
          module: 'VMB4RYNO'
        }
      ]
    }
  };

}).call(this);
