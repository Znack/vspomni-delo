BaseBackend = require('./baseBackend.js')

class TemplateBackend extends BaseBackend
  constructor: (@app)->
  getFrameTemplate: (request, sendResponse)->
    frameTemplate = document.getElementById('frame-template')
    return sendResponse({template: frameTemplate.innerHTML})

  getTemplateForAnonymous: (request, sendResponse)->
    templateForAnonymous = document.getElementById('anonymous-template')
    sendResponse({template: templateForAnonymous.innerHTML})

module.exports = TemplateBackend