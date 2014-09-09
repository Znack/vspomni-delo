ALLOWED_TYPES = ["standart" ,"warning", "loading"]

class Notification
  constructor: ()->
    @_notifications = []
  findSimilar: (type)->
    for notification in @_notifications
      if notification.type == type
        return notification
    return false
  createNotificationObject: (text, type)=>
    notificationObject = {
      text: text
    }
    if type in ALLOWED_TYPES
      notificationObject.type = type
    else
      notificationObject.type = undefined
    notificationObject.remove = ()=>
      @_notifications.splice(@_notifications.indexOf(notificationObject), 1)
    return notificationObject
  add: (text, type='standart', timeout=null, scope={})->
    similar = @findSimilar(type)
    return similar if similar
    notificationObject = @createNotificationObject(text, type)
    @_notifications.push(notificationObject)
    if timeout
      setTimeout(()->
        notificationObject.remove()
        scope.$apply()
      , timeout)
    return notificationObject
  all: ()->
    return @_notifications

module.exports = Notification