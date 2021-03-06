// Generated by CoffeeScript 1.6.3
(function() {
  angular.module('contenteditableDirective', ['ngSanitize']).directive('contenteditable', [
    '$sce', 'app', function($sce, app) {
      return {
        restrict: 'A',
        require: '?ngModel',
        link: function(scope, element, attrs, ngModel) {
          var read;
          if (!ngModel) {
            return;
          }
          ngModel.$render = function() {
            return element.html($sce.getTrustedHtml(ngModel.$viewValue || ''));
          };
          element.on('blur keyup change', function() {
            scope.$apply(read);
            return app.tracker.sendEvent('Todos', 'Blur todo editor', '');
          });
          return read = function() {
            var html;
            html = element.html();
            if (attrs.stripBr && html === '<br>') {
              html = '';
            }
            return ngModel.$setViewValue(html);
          };
        }
      };
    }
  ]);

}).call(this);
