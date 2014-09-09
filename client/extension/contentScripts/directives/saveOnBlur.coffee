angular.module('saveOnBlurDirective', []).
directive('saveOnBlur', [()->
  return {
  restrict: 'A', # only activate on element attribute
  require: 'ngModel', # get a hold of NgModelController
  link: (scope, element, attrs)->
    element.on('blur', ($event)->
      scope.updateTodo(scope.todo)
    )
  }
])