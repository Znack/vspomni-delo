(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var detectExtension, notificationControllers;

  detectExtension = require('../../common.js').detectExtension;

  notificationControllers = angular.module('notificationControllers', []);

  notificationControllers.controller('NotificationCtrl', [
    '$scope', function($scope) {
      var isLocalStorageAvailable;
      try {
        $scope.notificationExtensionNotInstalledClosed = localStorage.getItem("notificationExtensionNotInstalledClosed") || false;
        isLocalStorageAvailable = true;
      } catch (_error) {
        $scope.notificationExtensionNotInstalledClosed = false;
      }
      $scope.closeNotificationExtensionNotInstalled = function() {
        $scope.notificationExtensionNotInstalledClosed = !$scope.notificationExtensionNotInstalledClosed;
        if (isLocalStorageAvailable) {
          return localStorage.setItem("notificationExtensionNotInstalledClosed", $scope.notificationExtensionNotInstalledClosed);
        }
      };
      return detectExtension(function(err, success) {
        if ((err != null) && err.isChrome) {
          return $scope.notificationExtensionNotInstalled = true;
        }
      });
    }
  ]);

}).call(this);

},{"../../common.js":7}],2:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var exports, todoControllers, _removeItem, _today;

  todoControllers = angular.module('todoControllers', []);

  _today = new Date();

  _removeItem = function(arr, item) {
    var index;
    index = arr.indexOf(item);
    if (index > -1) {
      return arr.splice(index, 1);
    }
  };

  todoControllers.controller('TodoListCtrl', [
    '$scope', 'Todo', function($scope, Todo) {
      var _showActive;
      $scope.todos = Todo.query();
      _showActive = true;
      $scope.showActive = function() {
        var callback;
        if (arguments.length === 0) {
          return _showActive;
        }
        _showActive = arguments[0];
        callback = arguments[1];
        return $scope.loadTodos(callback);
      };
      $scope.loadTodos = function(callback) {
        var commonCallback;
        if (callback == null) {
          callback = null;
        }
        commonCallback = function(todos) {
          $scope.todos = todos;
          if (callback) {
            return callback(todos);
          }
        };
        if (_showActive) {
          return Todo.query(commonCallback);
        } else {
          return Todo.listOfRemoved(commonCallback);
        }
      };
      window.addEventListener('focus', function() {
        if ($scope.showActive()) {
          return $scope.showActive(true);
        }
      });
      $scope.isDeadLineToday = function(todo) {
        var _deadLine;
        _deadLine = new Date(todo.deadLine);
        return _deadLine.setHours(0, 0, 0, 0) === _today.setHours(0, 0, 0, 0);
      };
      $scope.createDeadLineHandler = function(todo) {
        return function(newDeadLine) {
          todo.deadLine = newDeadLine;
          return todo.$update();
        };
      };
      $scope.createTodo = function() {
        return $scope.showActive(true, function(todos) {
          return Todo.create({}, function(todo) {
            return $scope.todos.push(todo);
          });
        });
      };
      $scope.updateTodo = function(todo, callback, createNotification) {
        var loadingNotification;
        if (callback == null) {
          callback = null;
        }
        if (createNotification == null) {
          createNotification = true;
        }
        if (createNotification) {
          loadingNotification = todo.notifier().add('Сохраняется...', 'loading');
        }
        return todo.$update(function(todoData, getHeaders) {
          if (createNotification) {
            loadingNotification.remove();
            todo.notifier().add('Сохранено', 'standart', 1000, $scope);
          }
          if (callback != null) {
            return callback(todoData, getHeaders);
          }
        });
      };
      $scope.removeTodo = function(todo) {
        todo.$remove();
        return _removeItem($scope.todos, todo);
      };
      $scope.recoveryTodo = function(todo) {
        todo.removed = false;
        $scope.updateTodo(todo);
        return _removeItem($scope.todos, todo);
      };
      return $scope.setDefaultPosition = function(todo) {
        todo.clientX = 50;
        todo.clientY = 50;
        return $scope.updateTodo(todo);
      };
    }
  ]);

  exports = todoControllers;

}).call(this);

},{}],3:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  angular.module('contenteditableDirective', ['ngSanitize']).directive('contenteditable', [
    '$sce', function($sce) {
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
            return scope.$apply(read);
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

},{}],4:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  require('./services/todo.js');

  require('./controllers/todo.js');

  require('./controllers/notification.js');

  require('./directives/contenteditable.js');

  angular.module('todo', ['ngResource', 'ngCookies', 'ui.bootstrap.datetimepicker', 'contenteditableDirective', 'todoServices', 'todoControllers', 'notificationControllers']);

}).call(this);

},{"./controllers/notification.js":1,"./controllers/todo.js":2,"./directives/contenteditable.js":3,"./services/todo.js":5}],5:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Notification, interceptor, todoServices;

  Notification = require('../utils/notification');

  interceptor = {
    response: function(response) {
      var notification;
      if (response.resource instanceof Array) {
        response.resource.forEach(function(todo) {
          var notification;
          notification = new Notification();
          return todo.notifier = function() {
            return notification;
          };
        });
      } else {
        notification = new Notification();
        response.resource.notifier = function() {
          return notification;
        };
      }
      return response.resource;
    }
  };

  todoServices = angular.module('todoServices', ['ngResource']).factory('Todo', function($resource) {
    return $resource("/todos/:todoId", {}, {
      query: {
        method: 'GET',
        params: {
          todoId: ''
        },
        isArray: true,
        interceptor: interceptor
      },
      listOfRemoved: {
        method: 'GET',
        params: {
          todoId: 'removed'
        },
        isArray: true,
        interceptor: interceptor
      },
      create: {
        method: 'PUT',
        params: {
          todoId: ''
        }
      },
      update: {
        method: 'POST',
        params: {
          todoId: '@_id'
        },
        interceptor: interceptor
      },
      remove: {
        method: 'DELETE',
        params: {
          todoId: '@_id'
        }
      }
    });
  });

  module.exports = todoServices;

}).call(this);

},{"../utils/notification":6}],6:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var ALLOWED_TYPES, Notification,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ALLOWED_TYPES = ["standart", "warning", "loading"];

  Notification = (function() {
    function Notification() {
      this.createNotificationObject = __bind(this.createNotificationObject, this);
      this._notifications = [];
    }

    Notification.prototype.findSimilar = function(type) {
      var notification, _i, _len, _ref;
      _ref = this._notifications;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        notification = _ref[_i];
        if (notification.type === type) {
          return notification;
        }
      }
      return false;
    };

    Notification.prototype.createNotificationObject = function(text, type) {
      var notificationObject,
        _this = this;
      notificationObject = {
        text: text
      };
      if (__indexOf.call(ALLOWED_TYPES, type) >= 0) {
        notificationObject.type = type;
      } else {
        notificationObject.type = void 0;
      }
      notificationObject.remove = function() {
        return _this._notifications.splice(_this._notifications.indexOf(notificationObject), 1);
      };
      return notificationObject;
    };

    Notification.prototype.add = function(text, type, timeout, scope) {
      var notificationObject, similar;
      if (type == null) {
        type = 'standart';
      }
      if (timeout == null) {
        timeout = null;
      }
      if (scope == null) {
        scope = {};
      }
      similar = this.findSimilar(type);
      if (similar) {
        return similar;
      }
      notificationObject = this.createNotificationObject(text, type);
      this._notifications.push(notificationObject);
      if (timeout) {
        setTimeout(function() {
          notificationObject.remove();
          return scope.$apply();
        }, timeout);
      }
      return notificationObject;
    };

    Notification.prototype.all = function() {
      return this._notifications;
    };

    return Notification;

  })();

  module.exports = Notification;

}).call(this);

},{}],7:[function(require,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var detectExtension;

  detectExtension = function(callback) {
    var extId, isChrome;
    detectExtension = function(extId, callback) {
      return $.ajax({
        dataType: "json",
        url: "chrome-extension://" + extId + "/manifest.json",
        success: function(result) {
          callback(null, {
            status: "success",
            extId: extId
          });
          return false;
        },
        error: function() {
          callback({
            status: "error",
            isChrome: true,
            message: "The extension wasn't detected",
            extId: extId
          });
          return false;
        }
      });
    };
    isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
    extId = "djibejkjnciejcldejbajiihmickgloe";
    if (isChrome === true) {
      return detectExtension(extId, callback);
    } else {
      return callback({
        status: "error",
        isChrome: false,
        message: "The browser should be a Chrome",
        extId: extId
      });
    }
  };

  module.exports = {
    detectExtension: detectExtension
  };

}).call(this);

},{}]},{},[4])