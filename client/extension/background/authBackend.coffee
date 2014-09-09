config = require('../common.js').config

BaseBackend = require('./baseBackend.js')
NotificationBackend = require('./notificationBackend.js')

class AuthBackend extends BaseBackend
  constructor: (@app)->
    @_notificationBackend = new NotificationBackend()
  getCookie: (request, sendResponse)->
    chrome.cookies.get({
        url: config.site.url,
        name: "sid"
      }, (cookie)->
        return sendResponse({cookie: cookie})
    )
    return true

  checkAuth: (request, sendResponse)=>
    @connect({
      url: "#{config.site.url}/api/users/current",
      callback: (err, response)=>
        if err
          @_notificationBackend.create({
            params: {
              type: "basic"
              title: "Вспомни Дело — вы не авторизованы"
              message: "Нажмите на иконку расширения и авторизуйтесь"
              iconUrl: "img/128x128.png"
              notificationName: "anonimousNotification"
            }
          })
          return sendResponse({user: null})
        sendResponse({user: response})
    })
    return true

module.exports = AuthBackend