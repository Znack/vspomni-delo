config = require('../common.js').config
require('./services/todo.js')
require('./controllers/todo.js')
require('./directives/todoPanel.js')
require('./directives/contenteditable.js')
require('./directives/saveOnBlur.js')
require('./directives/widthConfigurable.js')

init = ()->
  app =
    working: false
    site: config.site

  app.service = analytics.getService('chrome_extension')
  app.tracker = app.service.getTracker('UA-54177324-2')

  chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
    if ("statusChecking" of request)
      return sendResponse({isWorking: app.working})

  getCookie(app)

getCookie = (app)->
  chrome.runtime.sendMessage {backendName: "authBackend", method: 'getCookie'}, (response)->
    app.cookie = response.cookie
    checkAuth(app)

checkAuth = (app)->
  chrome.runtime.sendMessage {backendName: "authBackend", method: 'checkAuth'}, (response)->
    if response.user?
      app.user = response.user
      createApp(app)
    else
      app.tracker.sendEvent('Error in extension', 'Content script opened by anonymous', '')

createApp = (app)->
  chrome.runtime.sendMessage({backendName: "templateBackend", method: "getFrameTemplate"}, (response)->
    element = document.createElement('div')
    element.innerHTML = response.template
    body = document.getElementsByTagName('body')[0]
    body.appendChild(element)

    angular.module('config', []).value('app', app)

    angular.module('todo', [
      'ngResource',
      'ngCookies',
      'ui.bootstrap.datetimepicker',
      'config',
      'todoPanelDirective',
      'saveOnBlurDirective',
      'contenteditableDirective',
      'widthConfigurableDirective',
      'todoServices',
      'todoControllers',
    ]).config( [
      '$compileProvider',
      ($compileProvider) ->
        currentImgSrcSanitizationWhitelist = $compileProvider.imgSrcSanitizationWhitelist()
        newImgSrcSanitizationWhiteList =
          currentImgSrcSanitizationWhitelist.toString().slice(0,-1) +
          '|chrome-extension:' +
          currentImgSrcSanitizationWhitelist.toString().slice(-1)
        $compileProvider.imgSrcSanitizationWhitelist(newImgSrcSanitizationWhiteList)
    ]).run([
      '$cookieStore',
      '$rootScope',
      ($cookieStore, $rootScope) ->
        $cookieStore.put('sid', app.cookie.value)
        $rootScope.app = app
        app.working = true
        app.tracker.sendAppView('ContentScript')
    ])

    angular.bootstrap(element, ['todo']);
  )

init()