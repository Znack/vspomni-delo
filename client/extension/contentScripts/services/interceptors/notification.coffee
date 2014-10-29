Notification = require('../../utils/notification')

module.exports = (response)->
  if response instanceof Array
    response.forEach((todo)->
      notification = new Notification()
      todo.notifier = ()->
        return notification
    )
  else
    notification = new Notification()
    response.notifier = ()->
      return notification
  return response