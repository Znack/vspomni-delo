AngularBackend = require('./angularBackend.js')
AuthBackend = require('./authBackend.js')
EmitterBackend = require('./emitterBackend.js')
NotificationBackend = require('./notificationBackend.js')
config = require('../common.js').config

app = {
  config: config
  service: analytics.getService('chrome_extension')
}
app.tracker = app.service.getTracker('UA-54177324-2')
app.tracker.sendAppView('Background')

chrome.runtime.onMessage.addListener(
  (request, sender, sendResponse)->
    if request.backendName of backends
      app.tracker.sendEvent('Background', 'Backend was launched', "backendName: #{request.backendName}, backendMethod: #{request.method}")
      return backends[request.backendName].handle(request, sendResponse)
    app.tracker.sendEvent(
      'Error in extension',
      'Background doesn\'t recognize backend',
      "backendName: #{request.backendName}, backendMethod: #{request.method}"
    )
)

backends = {
  angularBackend: new AngularBackend(app)
  authBackend: new AuthBackend(app)
  emitterBackend: new EmitterBackend(app)
  notificationBackend: new NotificationBackend(app)
}