config = require('../common.js').config

_sendMessageToActiveTab = (msg, callback)->
  chrome.tabs.query {active: true, currentWindow: true}, (tabs)->
    chrome.tabs.sendMessage(tabs[0].id, msg, callback)

init = ()->
  app = {}

  app.service = analytics.getService('chrome_extension')
  app.tracker = app.service.getTracker('UA-54177324-2')
  app.tracker.sendAppView('Popup')

  checkExtensionWorking(app)

checkExtensionWorking = (app)->
  _sendMessageToActiveTab {statusChecking: true}, (response)->
    if response
      # active tab support vd extension
      if response.isWorking
        checkAuth(app)
      else
        # error occured (connection lost or user is anonymous)
        unAuthorized(app)
    else
      # active tab does not support vd extension
      incorrectWindow(app)

checkAuth = (app)->
  chrome.runtime.sendMessage {backendName: "authBackend", method: 'checkAuth'}, (response)->
    if response.user?
      app.tracker.sendEvent('Popup', 'Popup opened successfully', '')
      app.user = response.user
      createPopup(app)
    else
      unAuthorized(app)

initEvents = (app)->
  $('body').on('click', 'a', ()->
    app.tracker.sendEvent('Popup', 'Link was opened from popup', "linkText:'#{$(this).text()}', linkUrl:#{$(this).attr('href')}")
    chrome.tabs.create({url: $(this).attr('href')})
    return false
  )
  $('.js-create-todo-btn').on('click', ()->
    app.tracker.sendEvent('Popup', 'Create todo btn', "")
    postUrl = "#{config.site.url}/todos/"
    xhr = new XMLHttpRequest()
    xhr.open('PUT', postUrl, true)
    xhr.send()
    _sendMessageToActiveTab({'refresh': "newTodo"})
  )

createPopup = (app)->
  initEvents(app)
  $('#display-name').text(app.user.displayName)

unAuthorized = (app)->
  app.tracker.sendEvent('Error in extension', 'Popup opened by anonymous', '')
  $('#anonymous-content').show()
  $('#authorized-content').hide()

incorrectWindow = (app)->
  app.tracker.sendEvent('Error in extension', 'Popup in incorrect page', '')
  $('#incorrect-window-content').show()
  $('#authorized-content').hide()

init()