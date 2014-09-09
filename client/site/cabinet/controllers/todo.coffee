todoControllers = angular.module('todoControllers', []);

_today = new Date()
_removeItem = (arr, item)->
  index = arr.indexOf(item)
  if index  > -1
    arr.splice(index , 1)

todoControllers.controller('TodoListCtrl', ['$scope', 'Todo',
  ($scope, Todo) ->
    $scope.todos = Todo.query()
    _showActive = true

    $scope.showActive = ()->
      if arguments.length == 0
        return _showActive
      _showActive = arguments[0]
      callback = arguments[1]
      $scope.loadTodos(callback)

    $scope.loadTodos = (callback=null)->
      commonCallback = (todos)->
        $scope.todos = todos
        if callback
          # means that arguments[0] is callback
          callback(todos)
      if _showActive
        Todo.query(commonCallback)
      else
        Todo.listOfRemoved(commonCallback)

    window.addEventListener('focus', ()->
      if $scope.showActive()
        $scope.showActive(true)
    )

    $scope.isDeadLineToday = (todo)->
      _deadLine = new Date(todo.deadLine)
      return _deadLine.setHours(0,0,0,0) == _today.setHours(0,0,0,0)

    $scope.createDeadLineHandler = (todo)->
      return (newDeadLine)->
        todo.deadLine = newDeadLine
        todo.$update()

    $scope.createTodo = ()->
      $scope.showActive(true, (todos)->
        Todo.create({}, (todo)->
          $scope.todos.push(todo)
        )
      )

    $scope.updateTodo = (todo, callback=null, createNotification=true)->
      if createNotification
        loadingNotification = todo.notifier().add('Сохраняется...', 'loading')
      todo.$update((todoData, getHeaders)->
        if createNotification
          loadingNotification.remove()
          todo.notifier().add('Сохранено', 'standart', 1000, $scope)
        if callback?
          callback(todoData, getHeaders)
      )

    $scope.removeTodo = (todo)->
      todo.$remove()
      _removeItem($scope.todos, todo)

    $scope.recoveryTodo = (todo)->
      todo.removed = false
      $scope.updateTodo(todo)
      _removeItem($scope.todos, todo)

    $scope.setDefaultPosition = (todo)->
      todo.clientX = 50
      todo.clientY = 50
      $scope.updateTodo(todo)
]);

exports = todoControllers