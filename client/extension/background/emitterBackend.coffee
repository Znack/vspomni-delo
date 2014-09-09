config = require('../common.js').config

BaseBackend = require('./baseBackend.js')

class EmitterBackend extends BaseBackend
  constructor: (@app)->

  createTodo: (request, sendResponse)->
    @connect({
      url: "#{config.site.url}/todos/",
      method: "PUT"
    })
    return true

  getTemplateForAnonymous: (request, sendResponse)->
    templateForAnonymous = document.getElementById('anonymous-template')
    sendResponse({template: templateForAnonymous.innerHTML})

module.exports = EmitterBackend