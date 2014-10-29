notificationInterceptor = require('./interceptors/notification.js')
emptyTodolistInterceptor = require('./interceptors/emptyTodolist.js')

_applyInterceptors = (response)->
  notificationInterceptor(response)
  emptyTodolistInterceptor(response)
  return response


todoServices = angular.module('todoServices', ['ngResource'])
  .factory('Todo', ($q, $timeout, app) ->
    _createPromise = (request)->
      throw new Error("action parameter is required") if not request.action
      deferred = $q.defer()
      if request.isArray
        data = []
      else
        data = {}
      data.$promise = deferred.promise
      chrome.runtime.sendMessage {backendName: "todoServiceBackend", method: request.action, data: request.todo || {}}, (response)->
        response = _applyInterceptors(response)
        $timeout(()->
          # use fake timeout for notifing scope to update

          if response instanceof Array
            newResponseArray = []
            for obj in response
              newResponseArray.push(new Todo(obj))
            response = newResponseArray
          else
            response = new Todo(response)
          angular.extend data, response
          deferred.resolve data
          request.callback(data)
        , 0)
      return data

    class Todo
      constructor: (data)->
        angular.extend this, data
      update: (callback=angular.noop)->
        data = _createPromise({action: "update", todo: @, callback: callback})
        return data
      remove: (callback=angular.noop)->
        data = _createPromise({action: "remove", todo: @, callback: callback})
        return data
      @query: (callback=angular.noop)->
        data = _createPromise({action: "query", isArray: true, callback: callback})
        return data
      @listOfRemoved: (callback=angular.noop)->
        data = _createPromise({action: "listOfRemoved", isArray: true, callback: callback})
        return data
      @create: (callback=angular.noop)->
        data = _createPromise({action: "create", callback: callback})
        return data

    return Todo
  )

module.exports = todoServices