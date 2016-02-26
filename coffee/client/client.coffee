# load modules
modules =
  VMB4RYNO: require './modules/VMB4RYNO'

class Client
  constructor: (server) ->
    # connect to the server
    @connection = new WebSocket(
      server.protocol + '://' + server.host + ':' + server.port
    )

    # listen for errors
    @connection.onerror = (error) ->
      console.log 'WebSocket Error ' + error
      return

    # listen for data
    @connection.onmessage = (message) ->
      data = JSON.parse message.data
      element = $ "[data-address='#{data.address}']" +
                  "[data-channel='#{data.channel}']"
      if (data.address + '_' + data.channel) of components
        try
          components[data.address + '_' + data.channel].process data
        catch error
          console.log error
          @constructor.warn 'Unsupported message received.'
      return

    # initialize components
    components = {}
    $('.velbus').each (index, element) =>
      # initialize module specific control element
      components[\
        ($(element).data 'address') +
        '_' +
        ($(element).data 'channel')
      ] = new modules[$(element).data 'module'] $(element), @send
      return
    return

  # display warning message to the user
  @warn: (message) ->
    icon_class = 'glyphicon glyphicon-exclamation-sign'
    bootbox.alert {
      message: "<span class='#{icon_class}' aria-hidden='true' /> #{message}"
    }
    return

  # send message to the server
  send: (json, counter = 0) =>
    if @connection.readyState
      @connection.send json
      return
    else
      if counter == 10
        @constructor.warn 'Cannot connect to server.'
        return
      setTimeout (
        =>
          @send json, counter + 1
          return
      ), 100
      return

module.exports = Client
