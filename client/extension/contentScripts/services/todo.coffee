notificationInterceptor = require('./interceptors/notification.js')
emptyTodolistInterceptor = require('./interceptors/emptyTodolist.js')

interceptor = {
  response: (response)->
    notificationInterceptor(response)
    emptyTodolistInterceptor(response)
    return response.resource
}

todoServices = angular.module('todoServices', ['ngResource'])
  .factory('Todo', ($resource, app) ->
    return $resource("#{app.site.url}/todos/:todoId", {}, {
      query: {method:'GET', params: {todoId: ''}, isArray:true, interceptor: interceptor},
      create: {method: 'PUT', params: {todoId: ''}},
      update: {method: 'POST', params: {todoId: '@_id'}, interceptor: interceptor}
      remove: {method: 'DELETE', params: {todoId: '@_id'}}
    })
)

module.exports = todoServices