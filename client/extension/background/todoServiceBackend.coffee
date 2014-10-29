config = require('../common.js').config

BaseBackend = require('./baseBackend.js')

class TodoServiceBackend extends BaseBackend
  constructor: (@app)->

  create: (request, sendResponse)->
    @connect({
      url: "#{config.site.url}/todos/"
      method: "PUT"
      callback: (err, data)->
        if err?
          return console.error(err)
        sendResponse data
    })
    return true
  query: (request, sendResponse)->
    @connect({
      url: "#{config.site.url}/todos",
      method: "GET"
      callback: (err, data)->
        if err?
          return console.error(err)
        sendResponse data
    })
    return true

  listOfRemoved: (request, sendResponse)->
    @connect({
      url: "#{config.site.url}/todos/removed",
      method: "GET"
      callback: (err, data)->
        if err?
          return console.error(err)
        sendResponse data
    })
    return true
  update: (request, sendResponse)->
    delete request.data['$$hashKey']
    @connect({
      url: "#{config.site.url}/todos/#{request.data['_id']}",
      method: "POST"
      data: request.data
      callback: (err, data)->
        if err?
          return console.error(err)
        sendResponse data
    })
    return true
  remove: (request, sendResponse)->
    @connect({
      url: "#{config.site.url}/todos/#{request.data['_id']}",
      method: "DELETE"
      callback: (err, data)->
        if err?
          return console.error(err)
        sendResponse data
    })
    return true

module.exports = TodoServiceBackend