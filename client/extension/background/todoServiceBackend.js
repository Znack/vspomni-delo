// Generated by CoffeeScript 1.6.3
(function() {
  var BaseBackend, TodoServiceBackend, config,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  config = require('../common.js').config;

  BaseBackend = require('./baseBackend.js');

  TodoServiceBackend = (function(_super) {
    __extends(TodoServiceBackend, _super);

    function TodoServiceBackend(app) {
      this.app = app;
    }

    TodoServiceBackend.prototype.create = function(request, sendResponse) {
      this.connect({
        url: "" + config.site.url + "/todos/",
        method: "PUT",
        callback: function(err, data) {
          if (err != null) {
            return console.error(err);
          }
          return sendResponse(data);
        }
      });
      return true;
    };

    TodoServiceBackend.prototype.query = function(request, sendResponse) {
      this.connect({
        url: "" + config.site.url + "/todos",
        method: "GET",
        callback: function(err, data) {
          if (err != null) {
            return console.error(err);
          }
          return sendResponse(data);
        }
      });
      return true;
    };

    TodoServiceBackend.prototype.listOfRemoved = function(request, sendResponse) {
      this.connect({
        url: "" + config.site.url + "/todos/removed",
        method: "GET",
        callback: function(err, data) {
          if (err != null) {
            return console.error(err);
          }
          return sendResponse(data);
        }
      });
      return true;
    };

    TodoServiceBackend.prototype.update = function(request, sendResponse) {
      delete request.data['$$hashKey'];
      this.connect({
        url: "" + config.site.url + "/todos/" + request.data['_id'],
        method: "POST",
        data: request.data,
        callback: function(err, data) {
          if (err != null) {
            return console.error(err);
          }
          return sendResponse(data);
        }
      });
      return true;
    };

    TodoServiceBackend.prototype.remove = function(request, sendResponse) {
      this.connect({
        url: "" + config.site.url + "/todos/" + request.data['_id'],
        method: "DELETE",
        callback: function(err, data) {
          if (err != null) {
            return console.error(err);
          }
          return sendResponse(data);
        }
      });
      return true;
    };

    return TodoServiceBackend;

  })(BaseBackend);

  module.exports = TodoServiceBackend;

}).call(this);

/*
//@ sourceMappingURL=todoServiceBackend.map
*/