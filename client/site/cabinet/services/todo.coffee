Notification = require('../utils/notification')

interceptor = {
  response: (response)->
    if response.resource instanceof Array
      response.resource.forEach((todo)->
        notification = new Notification()
        todo.notifier = ()->
          return notification
      )
    else
      notification = new Notification()
      response.resource.notifier = ()->
        return notification
    return response.resource
}

todoServices = angular.module('todoServices', ['ngResource'])
  .factory('Todo', ($resource) ->
    return $resource("/todos/:todoId", {}, {
      query: {method:'GET', params: {todoId: ''}, isArray:true, interceptor: interceptor},
      listOfRemoved: {method:'GET', params: {todoId: 'removed'}, isArray:true, interceptor: interceptor},
      create: {method: 'PUT', params: {todoId: ''}},
      update: {method: 'POST', params: {todoId: '@_id'}, interceptor: interceptor}
      remove: {method: 'DELETE', params: {todoId: '@_id'}}
    })
)

module.exports = todoServices