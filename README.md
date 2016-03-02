# node-velbus-client

This project should be used in combination with a server, such as
[node-velbus-server](https://github.com/pdpotter/node-velbus-server).

## Supported modules
* [VMB4RYNO](http://www.velbus.eu/products/view/?id=383130)
* [VMB4DC](http://www.velbus.eu/products/view/?id=384234)

## Installation on Raspberry Pi

Using Raspbian Jessie Lite
([download](https://www.raspberrypi.org/downloads/raspbian/),
[installation](https://www.raspberrypi.org/documentation/installation/installing-images/README.md),
[expand filesystem](https://www.raspberrypi.org/documentation/configuration/raspi-config.md),
[update](https://www.raspberrypi.org/documentation/raspbian/updating.md),
[static IP address](https://pi-hole.net/faq/how-do-i-set-a-static-ip-address-in-raspbian-jessie-using-etcdhcpcd-conf/))

### Install node (LTS version)
```bash
# add nodejs repository
sudo echo 'deb https://deb.nodesource.com/node_4.x jessie main' > /etc/apt/sources.list.d/nodesource.list
# add nodejs repository key
wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
# enable https repositories
sudo apt-get install apt-transport-https
# update installation sources
sudo apt-get update
# install nodejs
sudo apt-get install nodejs
```

### Install node-velbus-client
```bash
# update installation sources
sudo apt-get update
# install git
sudo apt-get install git
# clone this project
git clone https://github.com/pdpotter/node-velbus-client.git
# install dependencies
$(cd node-velbus-client; npm install)
# install initial config
$(cd node-velbus-client/server; cp config.sample.js config.js)
```

### Update node-velbus-client
If node-velbus-client is running as a daemon (see below), stop the daemon before
updating and start it again after updating.

```bash
# update node-velbus-client
$(cd node-velbus-client; git pull)
# update dependencies
$(cd node-velbus-client; npm install)
```

### Configure node-velbus-client
The client can be configured by editing the settings in `node-velbus-client/server/config.js`. The default settings are:

```javascript
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
```

#### Server port
The port at which the client will be reachable is can be changed by editing the
`server.port` setting (the default value is `8080`).

#### Components
The available components can be defined by editing the `layout` setting.

The components must be organized in categories, which are identified by a
machine name, that will be used as a url path. Each category must have a
(human readable) `name` and `components`.

Each component must have a (human readable) `name`, an `address` (the address on
the bus) and a `module` (the Velbus module type). If a module has multiple
channels, a `channel` must be defined as well.

#### Websocket server

The server that will receive the commands from the node-velbus-client and
transform them to Velbus commands can be configured by editing
`node-velbus-client/public/js/config.js`. The default settings are:

```javascript
var node_velbus_client_config = {
    server: {
        protocol: 'ws',
        host: '127.0.0.1',
        port: 8001
    }
};
```

The `server.host` setting should be changed to the IP address op the Raspberry,
which can be obtained by executing

```bash
ifconfig eth0 | grep "inet addr:"
```

The IP address consists of the four decimal numbers (with dots) following `inet
addr:`.


### Run node-velbus-client as a daemon
(based on [init-script-template](https://github.com/fhd/init-script-template/))

If node-velbus-client was not installed in the home directory of the pi user,
update the `dir` setting on line 12 in
`node-velbus-client/daemon/node-velbus-client` accordingly.

```bash
# copy daemon file
sudo cp node-velbus-client/daemon/node-velbus-client /etc/init.d
# make it executable
sudo chmod 755 /etc/init.d/node-velbus-client
```

To start the daemon, execute
```bash
sudo /etc/init.d/node-velbus-client start
```

To stop the daemon, execute
```bash
sudo /etc/init.d/node-velbus-client stop
```

To run the daemon on startup, execute
```bash
sudo update-rc.d node-velbus-client defaults
```
