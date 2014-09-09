BaseBackend = require('./baseBackend.js')

class AngularBackend extends BaseBackend
  constructor: (@app)->
  getFrameTemplate: (request, sendResponse)->
    frameTemplate = document.getElementById('frame-template')
    return sendResponse({template: frameTemplate.innerHTML})

module.exports = AngularBackend