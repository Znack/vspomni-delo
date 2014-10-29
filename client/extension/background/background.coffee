TemplateBackend = require('./templateBackend.js')
AuthBackend = require('./authBackend.js')
TodoServiceBackend = require('./todoServiceBackend.js')
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
  templateBackend: new TemplateBackend(app)
  authBackend: new AuthBackend(app)
  todoServiceBackend: new TodoServiceBackend(app)
  notificationBackend: new NotificationBackend(app)
}