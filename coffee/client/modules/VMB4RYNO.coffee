# 4 channel relay
# control element is a bootstrap-toggle
class VMB4RYNO
  constructor: (element, send) ->
    @element = element

    # set common message elements
    message =
      address: @element.data 'address'
      channel: @element.data 'channel'

    # add toggle element
    checkbox = $ '<input type="checkbox">'
    @element.append checkbox
    do checkbox.bootstrapToggle

    # send message to change relay status
    checkbox.change ->
      if $(this).prop 'checked'
        # don't update the element until the action is confirmed
        $(this).data('bs.toggle').off(true)
        message.command = 'switch_relay_on'
      else
        # don't update the element until the action is confirmed
        $(this).data('bs.toggle').on(true)
        message.command = 'switch_relay_off'
      send JSON.stringify message
      return

    # send message to obtain relay status
    # the status of the checkbox will be set when the response is retrieved
    message.command = 'relay_status_request'
    send JSON.stringify message
    return

  process: (data) ->
    switch data.message
      when 'relay_channel_on'
        @element.find('input').data('bs.toggle').on(true)
      when 'relay_channel_off'
        @element.find('input').data('bs.toggle').off(true)
      else
        throw new Error 'message_not_supported'

module.exports = VMB4RYNO
