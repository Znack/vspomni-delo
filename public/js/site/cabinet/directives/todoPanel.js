// Generated by CoffeeScript 1.6.3
(function() {
  var todoPanelDirective;

  todoPanelDirective = angular.module('todoPanelDirective', []);

  todoPanelDirective.directive('todoPanel', [
    '$document', function($document) {
      return {
        restrict: 'A',
        link: function(scope, element, attrs) {
          var initialMouseX, initialMouseY, mousemove, mouseup, startX, startY, todoElement;
          todoElement = element.parent();
          startY = scope.todo.clientY;
          startX = scope.todo.clientX;
          initialMouseX = 0;
          initialMouseY = 0;
          todoElement.css({
            position: 'fixed',
            top: startY,
            left: startX
          });
          mousemove = function($event) {
            var dx, dy;
            dx = $event.clientX - initialMouseX;
            dy = $event.clientY - initialMouseY;
            todoElement.css({
              top: startY + dy + 'px',
              left: startX + dx + 'px'
            });
            return false;
          };
          mouseup = function() {
            var position;
            position = todoElement.position();
            scope.todo.clientX = position.left;
            scope.todo.clientY = position.top;
            scope.updateTodo(scope.todo, angular.noop, false);
            $document.unbind('mousemove', mousemove);
            return $document.unbind('mouseup', mouseup);
          };
          return element.bind('mousedown', function($event) {
            startX = todoElement.prop('offsetLeft');
            startY = todoElement.prop('offsetTop');
            initialMouseX = $event.clientX;
            initialMouseY = $event.clientY;
            $document.bind('mousemove', mousemove);
            $document.bind('mouseup', mouseup);
            return false;
          });
        }
      };
    }
  ]);

  module.exports = todoPanelDirective;

}).call(this);
