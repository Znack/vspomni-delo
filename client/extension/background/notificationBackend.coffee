BaseBackend = require('./baseBackend.js')

class NotificationBackend extends BaseBackend
  constructor: (@app)->
    @_notifications = {}
    @_notificationCounter = 0
  create: (request, sendResponse)=>
    opt = {}
    notificationSettings = {}
    opt.type = request.params.type || "basic"
    opt.title = request.params.title || "-"
    opt.message = request.params.message || "-"
    opt.iconUrl = request.params.iconUrl || "img/128x128.png"
    notificationSettings.interval = request.params.notificationInterval || 3600000

    now = new Date()
    notificationSettings.name = request.params.notificationName || "note#{@_notificationCounter}"
    if not @_notifications[notificationSettings.name]
      # if there wasn't such notifications early
      @_notifications[notificationSettings.name] = {
        lastTime: now
      }

    if @_notifications[notificationSettings.name].lastTime.getTime() + notificationSettings.interval < now
      # if last notification was long time ago
      @_notifications[notificationSettings.name].lastTime = now

    if @_notifications[notificationSettings.name].lastTime == now
      # if now is good time for notification
      @_notificationCounter += 1
      chrome.notifications.create(notificationSettings.name, opt, ()->)
      setTimeout(()->
        chrome.notifications.clear(notificationSettings.name,()->)
      ,5000)
    @app.tracker.sendEvent('Background', 'notification was showed', opt.title)

module.exports = NotificationBackend