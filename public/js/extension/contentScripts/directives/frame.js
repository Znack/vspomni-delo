// Generated by CoffeeScript 1.6.3
(function() {
  var frameDirective;

  frameDirective = angular.module('frameDirective', []);

  frameDirective.directive('frame', [
    '$document', function($document) {
      return {
        restrict: 'A',
        link: function(scope, element, attrs) {
          var header, initialMouseX, initialMouseY, mousemove, mouseup, pin, startX, startY, _changeIsPinned, _changePosition;
          header = angular.element("<div class='draggable-header' />");
          element.prepend(header);
          pin = angular.element('<div class="draggable-pin" />');
          _changePosition = function() {
            var newTop, top;
            top = element.offset().top;
            if (pin.hasClass('active')) {
              newTop = top;
            } else {
              newTop = top - angular.element(document).scrollTop();
            }
            return element.css({
              top: newTop
            });
          };
          _changeIsPinned = function(shouldBePinned) {
            if (shouldBePinned) {
              pin.addClass('active');
              element.addClass('fixed');
              return scope.frame.isPinned = true;
            } else {
              element.removeClass('fixed');
              pin.removeClass('active');
              return scope.frame.isPinned = false;
            }
          };
          _changeIsPinned(scope.frame.isPinned);
          header.append(pin);
          pin.bind('click', function() {
            _changePosition();
            _changeIsPinned(!pin.hasClass('active'));
            return scope.$parent.updateFrame(scope.frame);
          });
          startY = scope.frame.clientY;
          startX = scope.frame.clientX;
          initialMouseX = 0;
          initialMouseY = 0;
          element.css({
            position: 'absolute',
            top: startY,
            left: startX
          });
          header.css({
            position: 'absolute'
          });
          mousemove = function($event) {
            var dx, dy;
            dx = $event.clientX - initialMouseX;
            dy = $event.clientY - initialMouseY;
            element.css({
              top: startY + dy + 'px',
              left: startX + dx + 'px'
            });
            return false;
          };
          mouseup = function() {
            var position;
            position = element.position();
            scope.frame.clientX = position.left;
            scope.frame.clientY = position.top;
            scope.$parent.updateFrame(scope.frame);
            $document.unbind('mousemove', mousemove);
            return $document.unbind('mouseup', mouseup);
          };
          return header.bind('mousedown', function($event) {
            startX = element.prop('offsetLeft');
            startY = element.prop('offsetTop');
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

  module.exports = frameDirective;

}).call(this);