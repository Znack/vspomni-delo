todoPanelDirective = angular.module('todoPanelDirective', []);

todoPanelDirective.directive('todoPanel', ['$document', 'app', ($document, app)->
  return {
  restrict: 'A',
  link: (scope, element, attrs)->
    todoElement = element.parent()

    startY = scope.todo.clientY
    startX = scope.todo.clientX
    initialMouseX = 0
    initialMouseY = 0

    todoElement.css({position: 'fixed', top: startY, left: startX})

    mousemove = ($event)->
      dx = $event.clientX - initialMouseX
      dy = $event.clientY - initialMouseY
      todoElement.css({
        top:  startY + dy + 'px',
        left: startX + dx + 'px'
      })
      return false

    mouseup = ()->
      position = todoElement.position()
      scope.todo.clientX = position.left
      scope.todo.clientY = position.top
      scope.updateTodo(scope.todo, angular.noop, false)
      $document.unbind('mousemove', mousemove)
      $document.unbind('mouseup', mouseup)
      app.tracker.sendEvent('Todos', 'Replaced todo window', "to x:#{position.left} and y:#{position.top}")

    element.bind('mousedown', ($event)->
      startX = todoElement.prop('offsetLeft')
      startY = todoElement.prop('offsetTop')
      initialMouseX = $event.clientX
      initialMouseY = $event.clientY
      $document.bind('mousemove', mousemove)
      $document.bind('mouseup', mouseup)
      return false;
    )
  }
]
)

module.exports = todoPanelDirective