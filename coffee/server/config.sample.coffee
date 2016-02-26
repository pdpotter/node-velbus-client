exports.server =
  port: 8080

exports.layout =
  'living-room':
    name: 'Living room'
    components: [
      {
        name: 'Lights'
        address: '01'
        channel: '1'
        speed: '2'
        module: 'VMB4DC'
      }
      {
        name: 'Fan'
        address: '02'
        channel: '2'
        module: 'VMB4RYNO'
      }
    ]
  kitchen:
    name: 'Kitchen'
    components: [
      {
        name: 'Lights'
        address: '01'
        channel: '3'
        speed: '2'
        module: 'VMB4DC'
      }
      {
        name: 'Fan'
        address: '02'
        channel: '4'
        module: 'VMB4RYNO'
      }
    ]
