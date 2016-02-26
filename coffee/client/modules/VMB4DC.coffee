# 4 channel dimmer
# control element is a seiyria-bootstrap-slider
class VMB4DC
  constructor: (element, send) ->
    @element = element

    # set common message elements
    message =
      address: @element.data 'address'
      channel: @element.data 'channel'

    # add slider
    input = $ '<input type="text">'
    input.attr('data-slider-min', 0)
    input.attr('data-slider-max', 100)
    input.attr('data-slider-value', 0)
    input.attr('data-slider-tooltip', 'always')
    @element.append input
    do input.slider

    # send message to change slider status
    input.on 'slideStop', ->
      # obtain the dimspeed
      speed = $(this).parent('.velbus').data 'speed'
      # diable the slider during the dim operation
      # the slider will be re-enabled when the dim operation has finished
      $(this).slider 'disable'
      message.command = 'set_dim_channel_value'
      message.value = $(this).slider 'getValue'
      message.speed = speed
      send JSON.stringify message
      return

    # send message to obtain dimmer channel status
    # the status of the slider will be set when the response is retrieved
    message.command = 'dimmer_channel_status_request'
    send JSON.stringify message
    return

  process: (data) ->
    switch data.message
      when 'dimmercontroller_status'
        @element.find('input').slider 'setValue', data.value
        # re-enable slider when led is no longer blinking
        if data.led_status & 0x70
          @element.find('input').slider 'enable'
      when 'slider_status'
        @element.find('input').slider 'setValue', data.value
      else
        throw new Error 'message_not_supported'

module.exports = VMB4DC
