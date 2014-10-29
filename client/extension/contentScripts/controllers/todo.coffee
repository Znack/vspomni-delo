todoControllers = angular.module('todoControllers', []);

_today = new Date()
_removeItem = (arr, item)->
  index = arr.indexOf(item)
  if index  > -1
    arr.splice(index , 1)

todoControllers.controller('TodoListCtrl', ['$scope', 'app', 'Todo',
  ($scope, app, Todo) ->
    $scope.todos = Todo.query()

    _setLoadingStatus = ()->
      _allNotifications = []
      $scope.todos.forEach((todo)->
        _allNotifications.push(todo.notifier().add("Загружается..", "loading"))
      )
      return _allNotifications

    _refreshCurrentTodos = (showNotifications)->
      # refresh all todos in scope
      if showNotifications
        allNotifications = _setLoadingStatus()
      Todo.query().$promise.then((todos)->
        $scope.todos = todos
        if showNotifications
          allNotifications.forEach((notification)->
            notification.remove()
          )
      )
    window.addEventListener('focus', ()->
      app.tracker.sendEvent('Todos', 'Reload all todos', 'after widnow focus')
      _refreshCurrentTodos(false)
    )

    chrome.runtime.onMessage.addListener (request, sender, sendResponse)->
      if ("refresh" of request)
        app.tracker.sendEvent('Todos', 'Reload all todos', 'after refresh order')
        _refreshCurrentTodos(true)
        return true

    $scope.createDeadLineHandler = (todo)->
      return (newDeadLine)->
        todo.deadLine = moment(newDeadLine).utc().format()
        todo.update()

    $scope.isDeadLineToday = (todo)->
      _deadLine = new Date(todo.deadLine)
      return _deadLine.setHours(0,0,0,0) == _today.setHours(0,0,0,0)

    $scope.createTodo = ()->
      Todo.create({}, (todo)->
        app.tracker.sendEvent('Todos', 'Create todo', '')
        $scope.todos.push(todo)
      )

    $scope.updateTodo = (todo, callback=null, createNotification=true)->
      if createNotification
        loadingNotification = todo.notifier().add('Сохраняется...', 'loading')
      todo.update((todoData)->
        app.tracker.sendEvent('Todos', 'Update todo', if createNotification then "with notification" else "without notification")
        if createNotification
          loadingNotification.remove()
          todo.notifier().add('Сохранено', 'standart', $scope, 1000)
        if callback?
          callback(todoData)
      )

    $scope.removeTodo = (todo)->
      todo.remove()
      app.tracker.sendEvent('Todos', 'Remove todo', '')
      _removeItem($scope.todos, todo)
]);

exports = todoControllers