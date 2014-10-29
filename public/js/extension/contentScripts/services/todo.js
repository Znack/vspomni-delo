// Generated by CoffeeScript 1.6.3
(function() {
  var emptyTodolistInterceptor, notificationInterceptor, todoServices, _applyInterceptors;

  notificationInterceptor = require('./interceptors/notification.js');

  emptyTodolistInterceptor = require('./interceptors/emptyTodolist.js');

  _applyInterceptors = function(response) {
    notificationInterceptor(response);
    emptyTodolistInterceptor(response);
    return response;
  };

  todoServices = angular.module('todoServices', ['ngResource']).factory('Todo', function($q, $timeout, app) {
    var Todo, _createPromise;
    _createPromise = function(request) {
      var data, deferred;
      if (!request.action) {
        throw new Error("action parameter is required");
      }
      deferred = $q.defer();
      if (request.isArray) {
        data = [];
      } else {
        data = {};
      }
      data.$promise = deferred.promise;
      chrome.runtime.sendMessage({
        backendName: "todoServiceBackend",
        method: request.action,
        data: request.todo || {}
      }, function(response) {
        response = _applyInterceptors(response);
        return $timeout(function() {
          var newResponseArray, obj, _i, _len;
          if (response instanceof Array) {
            newResponseArray = [];
            for (_i = 0, _len = response.length; _i < _len; _i++) {
              obj = response[_i];
              newResponseArray.push(new Todo(obj));
            }
            response = newResponseArray;
          } else {
            response = new Todo(response);
          }
          angular.extend(data, response);
          deferred.resolve(data);
          return request.callback(data);
        }, 0);
      });
      return data;
    };
    Todo = (function() {
      function Todo(data) {
        angular.extend(this, data);
      }

      Todo.prototype.update = function(callback) {
        var data;
        if (callback == null) {
          callback = angular.noop;
        }
        data = _createPromise({
          action: "update",
          todo: this,
          callback: callback
        });
        return data;
      };

      Todo.prototype.remove = function(callback) {
        var data;
        if (callback == null) {
          callback = angular.noop;
        }
        data = _createPromise({
          action: "remove",
          todo: this,
          callback: callback
        });
        return data;
      };

      Todo.query = function(callback) {
        var data;
        if (callback == null) {
          callback = angular.noop;
        }
        data = _createPromise({
          action: "query",
          isArray: true,
          callback: callback
        });
        return data;
      };

      Todo.listOfRemoved = function(callback) {
        var data;
        if (callback == null) {
          callback = angular.noop;
        }
        data = _createPromise({
          action: "listOfRemoved",
          isArray: true,
          callback: callback
        });
        return data;
      };

      Todo.create = function(callback) {
        var data;
        if (callback == null) {
          callback = angular.noop;
        }
        data = _createPromise({
          action: "create",
          callback: callback
        });
        return data;
      };

      return Todo;

    })();
    return Todo;
  });

  module.exports = todoServices;

}).call(this);
