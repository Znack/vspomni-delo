widthConfigurableDirective = angular.module('widthConfigurableDirective', []);

widthConfigurableDirective.directive('widthConfigurable', ['$document', 'app', ($document, app)->
  return {
  restrict: 'A',
  link: (scope, element, attrs)->
    todoElement = element
    regulator = angular.element('<div class="width-regulator"/>')
    todoElement.append(regulator)

    startWidth = scope.todo.width
    initialMouseX = 0

    todoElement.css('width', startWidth)

    mousemove = ($event)->
      dx = $event.clientX - initialMouseX
      todoElement.css({
        width: startWidth + dx + 'px'
      })
      return false

    mouseup = ()->
      scope.todo.width = parseInt(todoElement.width())
      scope.updateTodo(scope.todo, angular.noop, false)
      $document.unbind('mousemove', mousemove)
      $document.unbind('mouseup', mouseup)
      app.tracker.sendEvent('Todos', 'Configure todo width', "to value:#{scope.todo.width}")

    regulator.bind('mousedown', ($event)->
      startWidth = todoElement.width()
      initialMouseX = $event.clientX
      $document.bind('mousemove', mousemove)
      $document.bind('mouseup', mouseup)
      return false;
    )
  }
]
)

module.exports = widthConfigurableDirective