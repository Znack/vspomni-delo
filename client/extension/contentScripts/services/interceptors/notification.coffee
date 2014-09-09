Notification = require('../../utils/notification')

module.exports = (response)->
  if response.resource instanceof Array
    response.resource.forEach((todo)->
      notification = new Notification()
      todo.notifier = ()->
        return notification
    )
  else
    notification = new Notification()
    response.resource.notifier = ()->
      return notification
  return response.resource